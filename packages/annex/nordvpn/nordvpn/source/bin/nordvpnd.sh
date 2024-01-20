#!/bin/sh

. /etc/profile
oe_setup_addon service.nordvpn

SBIN="$(dirname ${0})/../sbin"
chmod +x "${SBIN}"/*
export PATH="${SBIN}:${PATH}"

exec nordvpnd