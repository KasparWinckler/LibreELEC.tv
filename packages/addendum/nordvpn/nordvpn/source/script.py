import sys

from resources.lib import nordvpn

if __name__ == "__main__":
    if sys.argv[0] == "":
        nordvpn.service()
    else:
        nordvpn.addon()
