#!/bin/sh

. /etc/profile
oe_setup_addon service.nordvpn

sysctl net.ipv4.ip_forward=1
for interface in eth0 wlan0 nordlynx; do
    if ! iptables -t nat -C POSTROUTING -j MASQUERADE -o "${interface}" 2>/dev/null; then
        iptables -t nat -A POSTROUTING -j MASQUERADE -o "${interface}"
        echo "Added MASQUERADE rule for ${interface}."
    else
        echo "MASQUERADE rule for ${interface} already exists. Skipping."
    fi
done

SBIN="$(dirname ${0})/../sbin"
chmod +x "${SBIN}"/*
export PATH="${SBIN}:${PATH}"

exec nordvpnd

