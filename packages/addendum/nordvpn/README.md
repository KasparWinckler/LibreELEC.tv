# NordVPN for LibreELEC

An add-on for NordVPN on LibreELEC. It includes a background service to run the `nordvpnd` daemon and a program add-on to log in and connect directly from the Kodi user interface.

## Building the Add-on

### Dependencies

Before building, verify the underlying library requirements:
* **Library Versions:** Ensure that the internal versions for `libdrop` and `libtelio` align exactly with NordVPN's official Linux client specifications. You can check the required version targets in the official [NordVPN Linux lib-versions.env repository](https://github.com/NordSecurity/nordvpn-linux/blob/main/lib-versions.env).
* **Host Utilities:** This add-on automatically builds and bundles `iproute2`. The standard version provided by LibreELEC's base `busybox` installation is too limited for NordVPN's networking requirements.

### Build Command

Execute the script from the root of your LibreELEC source tree using the syntax below:

```bash
NORDVPN_SALT="DoNotUseThisExposedSalt" \
CONCURRENCY_MAKE_LEVEL=8 \
PROJECT=RPi \
ARCH=aarch64 \
DEVICE=RPi5 \
scripts/create_addon nordvpn
```

### Environment Variables

* **`PROJECT` / `ARCH` / `DEVICE`:** Defines your target hardware platform. 
  * *Note:* For Raspberry Pi 5 (RPi5), ensure `ARCH` is set to `aarch64` to match modern 64-bit LibreELEC architectures. For other platforms, refer to the [Official LibreELEC Build Commands Guide](https://libreelec.tv).
* **`NORDVPN_SALT`:** The cryptographic salt used to encrypt local session data. **This value must remain identical across every subsequent build.** Changing it will break existing installations, causing users to lose their saved credentials and configuration settings during an update.
* **`CONCURRENCY_MAKE_LEVEL`:** Restricts the number of simultaneous compiler jobs. Lower this number if you experience Out Of Memory (OOM) errors on memory-constrained build environments.


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

This add-on is provided strictly as-is and as uncompiled source code. **Do not request pre-compiled binaries or a repository hosting them.**

* **Pull requests** are welcome and appreciated.
* **Issues** will be monitored, but there is no guarantee they will be actively addressed or resolved.

