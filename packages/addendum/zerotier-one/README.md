# Zerotier for LibreELEC

An add-on for Zerotier on LibreELEC. It starts the `service.zerotier-one` Systemd service that can be configured from the console.

## About Zerotier

[Zerotier](https://github.com/zerotier/ZeroTierOne) is a smart programmable Ethernet switch for planet Earth. It allows all networked devices, VMs, containers, and applications to communicate as if they all reside in the same physical data center or cloud region.

## About the Add-on

This add-on is provided as-is as a source code.
Do not request binaries, let alone a repository hosting them.
Pull requests are welcome.
Issues will be monitored, but there is no guarantee they will be actively addressed or resolved.

## Building the Add-on

Execute the build script from the root of your LibreELEC source tree using the syntax below:

```bash
CONCURRENCY_MAKE_LEVEL=8 \
PROJECT=RPi \
ARCH=aarch64 \
DEVICE=RPi5 \
scripts/create_addon zerotier-one
```

`CONCURRENCY_MAKE_LEVEL` restricts the number of simultaneous compiler jobs. Lower this number if you experience Out Of Memory (OOM) errors on memory-constrained build environments.
Other details explained [here](https://wiki.libreelec.tv/development/build-commands/build-addons).

## Using the Add-on

### Configuration

Configure Zerotier by running the `zerotier-one` command at the console, for example:

```bash
zerotier-one -h
zerotier-one -q -h
zerotier-one -q join <network ID>
zerotier-one -q info
```

### Systemd Service

Control the `service.zerotier-one` Systemd service by running the `journalctl`or `systemctl` commands at the console, for example:

```bash
journalctl -u service.zerotier-one
systemctl restart service.zerotier-one
```

