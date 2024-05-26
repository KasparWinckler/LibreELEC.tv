import xbmc
import xbmcaddon

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo("id")


def log(message, loginfo=True):
    xbmc.log(f"{ADDON_ID} - {message}", xbmc.LOGINFO if loginfo else xbmc.LOGDEBUG)


class Player(xbmc.Player):
    def __init__(self):
        super().__init__()
        self.file = ""

    def get_file(self):
        if self.isPlaying():
            file = self.getPlayingFile()
        else:
            file = ""
        if file != self.file:
            log(f"File change from '{self.file}' to '{file}'")
            self.file = file

    def onAVChange(self):
        file = self.getPlayingFile()
        log(f"onAVChange to '{file}'")


if __name__ == "__main__":
    log("Service started")
    monitor = xbmc.Monitor()
    player = Player()
    while not monitor.waitForAbort(1):
        player.get_file()
    log("Service stopped")
