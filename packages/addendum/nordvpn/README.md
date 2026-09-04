# NordVPN for LibreELEC

An add-on for NordVPN on LibreELEC systems.

## Building the Add-on

You can compile the add-on package by running the following command in your terminal. Replace the placeholder values with your specific hardware details:

```
NORDVPN_SALT="DoNotUseThisExposedSalt" \
CONCURRENCY_MAKE_LEVEL=8 \
ARCH=arm64 \
DEVICE=RPi5 \
PROJECT=RPi \
scripts/create_addon nordvpn
```

| Variable | Description |
| :--- | :--- |
| `NORDVPN_SALT` | The cryptographic salt used to encrypt local session data. **This value must remain identical across every build** to ensure saved user credentials and settings are not lost between updates. |
| `CONCURRENCY_MAKE_LEVEL` | Restricts the number of parallel compile jobs. Lowering this value helps **avoid Out Of Memory (OOM) errors** on resource-constrained build environments. |
| `ARCH` | The target hardware architecture (e.g., `x86_64`, `arm64`). |
| `DEVICE` | The specific target device profile (e.g., `Generic`, `RPi5`). |
| `PROJECT` | The overall project identifier (e.g., `RPi`). |

## Runtime Dependencies

The add-on relies on the following dependencies to manage routing and networking rules at runtime:

* **`iproute2`** – Built and shipped with the add-on because the version provided by the host operating system's `busybox` is incomplete.
* **`ipset`** – Provided by the host operating system.
* **`nftables`** – Provided by the host operating system.
* **`sysctl`** – Provided by the host operating system's `busybox`.

## Configuration

You can configure NordVPN in Kodi by running the NordVPN program add-on, or via the console using the `nordvpn` command:

```
nordvpn login --token <TOKEN>
nordvpn connect albania
```

## Testing & Verification

The console commands below can be used to verify your current VPN connection status and validate your network routing.

### 1. Check NordVPN Status
Verify the connection status of NordVPN:
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

### 2. Verify Geolocation
Ensure public-facing web traffic routes correctly through NordVPN, e.g., with the ip-api.com service:
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

### 3. Inspect Physical Interfaces
Test individual system hardware interfaces. They remain tied to your real location.
```
# Test the primary wired interface
curl --interface eth0 ip-api.com

# Test the primary wireless interface
curl --interface wlan0 ip-api.com
```

## Viewing Logs

You can view the log of the `nordvpnd` daemon in the console with the following command:

```
journalctl -u service.nordvpn
```

## Support & Contributions

This package is provided strictly as-is and as uncompiled source code. **Do not request pre-compiled binaries or a repository hosting them.**

* **Pull Requests** are welcome and appreciated.
* **Issues** will be monitored, but there is no guarantee they will be actively addressed or resolved.

