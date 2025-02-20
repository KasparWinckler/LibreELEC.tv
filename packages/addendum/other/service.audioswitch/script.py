import json
import xbmc
import xbmcaddon
import xbmcgui
import xbmcplugin

DEVICE_AUDIO = "device_audio"
DEVICE_VIDEO = "device_video"

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo("id")
ADDON_NAME = ADDON.getAddonInfo("name")
DIALOG = xbmcgui.Dialog()


def log(message, loginfo=True):
    xbmc.log(f"{ADDON_ID} - {message}", xbmc.LOGINFO if loginfo else xbmc.LOGDEBUG)


def jsonrpc(method, **params):
    req = json.dumps(dict(id=1, jsonrpc="2.0", method=method, params=params))
    rsp = xbmc.executeJSONRPC(req)
    return json.loads(rsp)["result"]


def jsonrpc_get_audiodevice():
    return jsonrpc("Settings.GetSettingValue", setting="audiooutput.audiodevice")[
        "value"
    ]


def jsonrpc_get_audiodevice_options():
    for setting in jsonrpc("Settings.GetSettings")["settings"]:
        if setting["id"] == "audiooutput.audiodevice":
            return setting["options"]


def jsonrpc_get_muted():
    return jsonrpc("Application.GetProperties", properties=["muted"])["muted"]


def jsonrpc_set_audiodevice(audiodevice):
    jsonrpc(
        "Settings.SetSettingValue", setting="audiooutput.audiodevice", value=audiodevice
    )


def jsonrpc_set_mute(mute):
    jsonrpc("Application.SetMute", mute=mute)


def settings_get_device(id):
    value = ADDON.getSetting(id)
    return value if value else jsonrpc_get_audiodevice()


def script():
    menu = [
        ["Device for audio", DEVICE_AUDIO],
        ["Device for video", DEVICE_VIDEO],
    ]
    index = 0
    while True:
        index = DIALOG.select(ADDON_NAME, [item[0] for item in menu], preselect=index)
        if index < 0:
            break
        script_set_device(f"{ADDON_NAME} - {menu[index][0]}", menu[index][1])


def script_set_device(heading, id):
    options = jsonrpc_get_audiodevice_options()
    labels = [option["label"] for option in options]
    values = [option["value"] for option in options]
    value = ADDON.getSetting(id)
    index = values.index(value) if value in values else 0
    while True:
        index = DIALOG.select(heading, labels, preselect=index)
        if index < 0:
            break
        ADDON.setSetting(id, values[index])


def service():
    log("Service started")
    player = xbmc.Player()
    monitor = xbmc.Monitor()
    old_device = jsonrpc_get_audiodevice()
    while not monitor.waitForAbort(1):
        if player.isPlaying():
            if player.isPlayingAudio():
                new_device = settings_get_device(DEVICE_AUDIO)
            else:
                new_device = settings_get_device(DEVICE_VIDEO)
            if old_device != new_device:
                log(f"Switching to {new_device}")
                jsonrpc_set_audiodevice(new_device)
                log(f"Switched to {new_device}")
                old_device = new_device
    log("Service stopped")


if __name__ == "__main__":
    if sys.argv[0]:
        script()
    else:
        service()
