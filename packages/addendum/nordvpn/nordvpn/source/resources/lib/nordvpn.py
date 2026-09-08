import json
import os
import subprocess
import tempfile

import xbmc
import xbmcaddon
import xbmcgui

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo("id")
ADDON_ICON = ADDON.getAddonInfo("icon")
ADDON_NAME = ADDON.getAddonInfo("name")
ADDON_PATH = ADDON.getAddonInfo("path")
DIALOG = xbmcgui.Dialog()

NORDVPN = os.path.join(ADDON_PATH, "bin", "nordvpn")

TMP_DIR = tempfile.gettempdir()
STATUS_FILE = os.path.join(TMP_DIR, f"{ADDON_ID}_status.json")


def kodi_concat(prefix, suffix):
    return f"{prefix}[CR]{suffix}" if prefix and suffix else (prefix or suffix)


def to_kodi_plain(text):
    return "[CR]".join(text.splitlines())


def to_kodi_bold(text):
    return f"[B]{to_kodi_plain(text)}[/B]"


def to_kodi_italic(text):
    return f"[I]{to_kodi_plain(text)}[/I]"


def log(message, level=None):
    xbmc.log(f"{ADDON_ID} - {message}", xbmc.LOGDEBUG if level is None else level)


def notification(message):
    DIALOG.notification(
        ADDON_NAME,
        message,
        ADDON_ICON,
    )


class NordVPN:
    def __init__(self, command):
        self.heading = "login" if command.startswith("login") else command

        args = [NORDVPN] + command.strip().split()

        try:
            process = subprocess.run(
                args,
                capture_output=True,
                check=False,
                encoding="utf-8",
                timeout=5,
            )
            error = process.returncode or process.stderr
            self.stderr = process.stderr
            self.stdout = process.stdout
        except Exception as e:
            error = True
            self.stderr = str(e)
            self.stdout = ""

        if error:
            level = xbmc.LOGWARNING
            log(self.heading, level=level)
            for line in self.stdout.splitlines():
                log(line, level=level)
            for line in self.stderr.splitlines():
                log(line, level=level)

        self.status = self.get_status() if command.startswith("status") else {}

    def get_report(self):
        report = to_kodi_bold(self.heading)
        report = kodi_concat(report, to_kodi_plain(self.stdout))
        report = kodi_concat(report, to_kodi_italic(self.stderr))
        return report

    def get_status(self):
        sep = ": "
        keys = {"Status", "Country", "Hostname"}

        old_status = {}
        try:
            with open(STATUS_FILE, "r") as f:
                old_status = json.load(f)
        except Exception as e:
            log(f"Failed to read status file: {e}")

        new_status = {
            k.strip(): v.strip()
            for line in self.stdout.splitlines()
            if sep in line
            for k, v in [line.split(sep, 1)]
        }

        new_values = {k: new_status[k] for k in keys if k in new_status}
        old_values = {k: old_status[k] for k in keys if k in old_status}

        if new_values != old_values:
            try:
                os.makedirs(os.path.dirname(STATUS_FILE), exist_ok=True)
                with open(STATUS_FILE, "w") as f:
                    json.dump(new_status, f)
            except OSError as e:
                log(f"Failed to write status file: {e}")

            notification(
                kodi_concat(
                    new_status.get("Status", "Unknown"),
                    new_status.get("Country", ""),
                )
            )

        return new_status


def service():
    monitor = xbmc.Monitor()

    while True:
        NordVPN("status")

        try:
            polling_time = int(ADDON.getSetting("polling_time"))
        except (ValueError, TypeError):
            polling_time = 20

        if monitor.waitForAbort(polling_time):
            break


def addon():
    menu = [
        ("Connect", addon_connect),
        ("Disconnect", addon_disconnect),
        ("Autoconnect", addon_autoconnect),
        ("Login", addon_login),
        ("Logout", addon_logout),
        ("Information", addon_information),
    ]

    labels = [label for label, _ in menu]
    index = 0

    while True:
        index = DIALOG.select(ADDON_NAME, labels, preselect=index)
        if index < 0:
            break

        label, action = menu[index]
        action(label)


def addon_autoconnect(heading):
    country = addon_country(heading, "off", "on")

    if country is None:
        return

    if country == "on":
        country = ""

    commands = [
        "set autoconnect off",
        "settings",
    ]

    if country != "off":
        commands.insert(1, f"set autoconnect on {country}")

    addon_report(heading, *commands)


def addon_connect(heading):
    country = addon_country(heading, "")

    if country is None:
        return

    addon_report(
        heading,
        f"connect {country}",
        "status",
    )


def addon_country(heading, *prefix):
    countries = list(prefix) + NordVPN("countries").stdout.split()
    index = DIALOG.select(f"{heading} option", countries)
    if index >= 0:
        return countries[index]


def addon_disconnect(heading):
    addon_report(
        heading,
        "disconnect",
        "status",
    )


def addon_information(heading):
    addon_report(
        heading,
        "version",
        "status",
        "settings",
        "account",
    )


def addon_login(heading):
    token = DIALOG.input(
        f"{heading} token",
        type=xbmcgui.INPUT_ALPHANUM,
        option=xbmcgui.ALPHANUM_HIDE_INPUT,
    )
    if token:
        addon_report(
            heading,
            f"login --token {token}",
            "account",
        )


def addon_logout(heading):
    addon_report(
        heading,
        "logout",
        "account",
    )


def addon_report(heading, *commands):
    content = ""
    for command in commands:
        content = kodi_concat(content, NordVPN(command).get_report())
    DIALOG.textviewer(heading, content, usemono=True)
