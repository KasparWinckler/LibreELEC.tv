import json

import xbmc
import xbmcaddon
import xbmcgui


DEVICE_AUDIO = "device_audio"
DEVICE_VIDEO = "device_video"

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo("id")
ADDON_NAME = ADDON.getAddonInfo("name")
DIALOG = xbmcgui.Dialog()


def log(message, level=xbmc.LOGINFO):
    xbmc.log(f"{ADDON_ID} - {message}", level)


def jsonrpc(method, **params):
    return (
        json.loads(
            xbmc.executeJSONRPC(
                json.dumps(
                    {
                        "jsonrpc": "2.0",
                        "method": method,
                        "params": params,
                        "id": 1,
                    }
                )
            )
        ).get("result")
        or {}
    )


def jsonrpc_get_audiodevice():
    return (
        jsonrpc(
            "Settings.GetSettingValue",
            setting="audiooutput.audiodevice",
        ).get("value")
        or ""
    )


def jsonrpc_get_audiodevice_options():
    for setting in jsonrpc("Settings.GetSettings").get("settings") or []:
        if setting.get("id") == "audiooutput.audiodevice":
            return setting.get("options") or []
    return []


def jsonrpc_set_audiodevice(audiodevice):
    jsonrpc(
        "Settings.SetSettingValue",
        setting="audiooutput.audiodevice",
        value=audiodevice,
    )
    log(f"Audio device set to: {audiodevice}")


def settings_get_audiodevice(device_type):
    return ADDON.getSetting(device_type) or jsonrpc_get_audiodevice()


class Player(xbmc.Player):
    def onAVStarted(self):
        if not self.isPlaying():
            return

        if self.isPlayingVideo():
            audiodevice = settings_get_audiodevice(DEVICE_VIDEO)
        else:
            audiodevice = settings_get_audiodevice(DEVICE_AUDIO)

        if not audiodevice or audiodevice == jsonrpc_get_audiodevice():
            return

        jsonrpc_set_audiodevice(audiodevice)


def service():
    player = Player()
    xbmc.Monitor().waitForAbort()


def script():
    menu = {
        ADDON.getLocalizedString(32001): DEVICE_AUDIO,
        ADDON.getLocalizedString(32003): DEVICE_VIDEO,
    }
    labels = list(menu.keys())
    index = 0
    while True:
        index = DIALOG.select(ADDON_NAME, labels, preselect=index)
        if index < 0:
            break
        label = labels[index]
        script_set_device(f"{ADDON_NAME} - {label}", menu[label])


def script_set_device(heading, device_type):
    device_options = jsonrpc_get_audiodevice_options()
    if not device_options:
        return

    labels = [option["label"] for option in device_options]
    values = [option["value"] for option in device_options]

    current_value = ADDON.getSetting(device_type)
    index = values.index(current_value) if current_value in values else 0

    while True:
        index = DIALOG.select(heading, labels, preselect=index)
        if index < 0:
            break
        ADDON.setSetting(device_type, values[index])
