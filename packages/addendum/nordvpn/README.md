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

## Logs

You can view the log of the `nordvpnd` daemon in the console with the `journalctl -u service.nordvpn` command.

## Support

This package is provided strictly as-is and as uncompiled source code. **Do not request binaries or a repository.**

* **Pull Requests** are welcomed.
* **Issues** will be monitored, but there is absolutely no guarantee they will be addressed or resolved.

