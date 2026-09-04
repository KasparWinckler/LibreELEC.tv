# NordVPN for LibreELEC

An add-on for NordVPN on LibreELEC and CoreELEC systems.

## Building the Add-on

You can compile the add-on package by running the following command in your terminal:

```
NORDVPN_SALT=nordvpn_salt \
CONCURRENCY_MAKE_LEVEL=n \
ARCH=arch \
DEVICE=device \
PROJECT=project \
scripts/create_addon nordvpn
```

| Variable | Description |
| :--- | :--- |
| `NORDVPN_SALT` | The cryptographic salt used to encrypt local session data. **This value must remain identical across every build** to ensure saved user credentials and settings are not lost between updates. |
| `CONCURRENCY_MAKE_LEVEL` | Restricts the number of parallel compile jobs. Lowering this value helps **avoid Out Of Memory errors** on resource-constrained build environments. |
| `ARCH` | The target hardware architecture (e.g., `x86_64`, `arm64`). |
| `DEVICE` | The specific target device profile (e.g., `Generic`, `RPi5`). |
| `PROJECT` | The overall project identifier (e.g., `RPi`). |

## Runtime Dependencies

The add-on relies on the following dependencies to manage routing and networking rules at runtime:

* **`iproute2`** – Built and shipped with the addon, because the version provided by the host operating system's `busybox` is incomplete.
* **`ipset`** – Provided by the host operating system.
* **`nftables`** – Provided by the host operating system.
* **`sysctl`** – Provided by the host operating system's `busybox`.

## Configuration

You can configure NordVPN in Kodi by running the program addon or in the console with the `nordvpn` command, e.g., `nordvpn status`.

## Testing

The console commands below may be used to verify your current VPN connection status and validate your network routing by mapping both virtual and physical network configurations.

### 1. Check NordVPN Daemon Status
Verify if the client is actively connected and inspect its target endpoint details:
```
nordvpn status

# Example output:
Status: Connected
Server: Albania #111 - Virtual
Hostname: al111.nordvpn.com
IP: 186.247.44.3
Country: Albania
City: Tirana
...
```

### 2. Verify Geolocation and Routing Data
Query the `ip-api.com` endpoint to ensure public-facing web traffic routes correctly through NordVPN:
```
curl ip-api.com

# Example output:
{
  "status"       : "success",
  "continent"    : "Europe",
  "continentCode": "EU",
  "country"      : "Albania",
  "countryCode"  : "AL",
  "region"       : "11",
  "regionName"   : "Tirana",
  "city"         : "Tirana",
  "district"     : "",
  "zip"          : "",
  "lat"          : 41.3253,
  "lon"          : 19.8184,
  "timezone"     : "Europe/Tirane",
  "offset"       : 7200,
  "currency"     : "ALL",
  "isp"          : "Datacamp Limited",
  "org"          : "PacketHub S.A",
  "as"           : "AS212238 Datacamp Limited",
  "asname"       : "CDNEXT",
  "mobile"       : false,
  "proxy"        : true,
  "hosting"      : false,
  "query"        : "186.247.44.247"
}
```

### 3. Inspect Physical Interface Routing
Individual system hardware interfaces remain at your real location:
```
# Test the primary wired interface
curl --interface eth0 ip-api.com

# Test the primary wireless interface
curl --interface wlan0 ip-api.com
```

## Logs

You can view the log of the `nordvpnd` daemon in the console with the `journalctl -u service.nordvpn` command.

## Support

This package is provided strictly as-is and as uncompiled source code. **Do not request binaries or a repository.**

* **Pull Requests** are welcomed.
* **Issues** will be monitored, but there is absolutely no guarantee they will be addressed or resolved.

