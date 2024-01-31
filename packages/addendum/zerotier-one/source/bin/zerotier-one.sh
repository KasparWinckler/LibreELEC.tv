#!/bin/sh

. /etc/profile
oe_setup_addon service.zerotier-one

chmod +x ${ADDON_DIR}/bin.private/*

PATH=${ADDON_DIR}/bin.private:${PATH} \
ZEROTIER_HOME=${ADDON_HOME} \
exec zerotier-one "${@}"
