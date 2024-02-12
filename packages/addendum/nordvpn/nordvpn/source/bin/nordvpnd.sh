#!/bin/sh

. /etc/profile
oe_setup_addon service.nordvpn

sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -j MASQUERADE -o eth0
iptables -t nat -A POSTROUTING -j MASQUERADE -o wlan0
iptables -t nat -A POSTROUTING -j MASQUERADE -o nordlynx

SBIN="$(dirname ${0})/../sbin"
chmod +x "${SBIN}"/*
export PATH="${SBIN}:${PATH}"

exec nordvpnd