import subprocess
import sys
import xbmc
import xbmcaddon
import xbmcgui

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo("id")
ADDON_ICON = ADDON.getAddonInfo("icon")
ADDON_NAME = ADDON.getAddonInfo("name")
ADDON_PATH = ADDON.getAddonInfo("path")
DIALOG = xbmcgui.Dialog()
NORDVPN = f"{ADDON_PATH}bin/nordvpn"


def log(message, loginfo=False):
    xbmc.log(f"{ADDON_ID} - {message}", xbmc.LOGINFO if loginfo else xbmc.LOGDEBUG)


def strip_std(std):
    return std[std.rfind(b"\r") + 1 : -1].decode("utf-8")


def run(command):
    process = subprocess.run(command.split(), capture_output=True)
    process.stdout = strip_std(process.stdout)
    process.stderr = strip_std(process.stderr)
    log(f"run: {command}")
    log(f"out: {process.stdout}")
    log(f"err: {process.stderr}")
    return process


def report(command):
    process = run(command)
    output = f"[B]{command.removeprefix(NORDVPN).lstrip()}[/B]"
    if process.stdout:
        output += f"[CR]{process.stdout}"
    if process.stderr:
        output += f"[CR][I]{process.stderr}[/I]"
    return output


def addon():
    log("addon")
    menu = [
        ["Information", addon_information],
        ["Connect", addon_connect],
        ["Disconnect", addon_disconnect],
        ["Autoconnect", addon_autoconnect],
        ["Login", addon_login],
        ["Logout", addon_logout],
    ]
    index = 0
    while True:
        index = DIALOG.select(ADDON_NAME, [item[0] for item in menu], preselect=index)
        if index < 0:
            break
        menu[index][1](menu[index][0])


def addon_autoconnect(heading):
    prefix = ["off", "on"]
    country = addon_country(heading, prefix=prefix)
    if country is None:
        return
    elif country == "off":
        addon_report(
            heading,
            f"{NORDVPN} set autoconnect off",
            f"{NORDVPN} disconnect",
            f"{NORDVPN} status",
            f"{NORDVPN} settings",
        )
    else:
        if country == "on":
            country = ""
        addon_report(
            heading,
            f"{NORDVPN} set autoconnect off",
            f"{NORDVPN} set autoconnect on {country}",
            f"{NORDVPN} connect {country}",
            f"{NORDVPN} status",
            f"{NORDVPN} settings",
        )


def addon_connect(heading):
    country = addon_country(heading, prefix=[""])
    if country is not None:
        addon_report(
            heading,
            f"{NORDVPN} connect {country}",
            f"{NORDVPN} status",
        )


def addon_country(heading, prefix=[]):
    countries = prefix + run(f"{NORDVPN} countries").stdout.split()
    index = DIALOG.select(f"{heading} option", countries)
    if index >= 0:
        return countries[index]


def addon_disconnect(heading):
    addon_report(
        heading,
        f"{NORDVPN} disconnect",
        f"{NORDVPN} status",
    )


def addon_information(heading):
    addon_report(
        heading,
        f"{NORDVPN} version",
        f"{NORDVPN} status",
        f"{NORDVPN} settings",
        f"{NORDVPN} account",
    )


def addon_login(heading):
    token = DIALOG.input(f"{heading} token")
    if token:
        addon_report(
            heading,
            f"{NORDVPN} login --token {token}",
            f"{NORDVPN} account",
        )


def addon_logout(heading):
    addon_report(
        heading,
        f"{NORDVPN} logout --persist-token",
        f"{NORDVPN} account",
    )


def addon_report(heading, *commands):
    DIALOG.textviewer(
        heading,
        "[CR][CR]".join([report(command) for command in commands]),
        usemono=True,
    )


def notification(*args):
    DIALOG.notification(
        ADDON_NAME,
        "[CR]".join(
            [
                line
                for line in run(f"{NORDVPN} status").stdout.splitlines()
                if line.split(":")[0] in ["Status", "Country"]
            ]
        ),
        ADDON_ICON,
    )


def service():
    log("service")
    notification()


if __name__ == "__main__":
    log(str(sys.argv))
    if sys.argv[0] == "":
        service()
    elif len(sys.argv) == 1:
        addon()
    elif sys.argv[1] == "notification":
        notification(*sys.argv[1:])
