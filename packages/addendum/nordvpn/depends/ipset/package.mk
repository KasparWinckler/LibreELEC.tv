PKG_NAME="ipset"
PKG_VERSION="7.20"
PKG_SHA256="6ae85b1d81832c2b67df7330d3671a3462e39ec98328056a18a29d44c27709e5"
PKG_LICENSE="GPLv2"
PKG_SITE="https://ipset.netfilter.org/"
PKG_URL="https://ipset.netfilter.org/ipset-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libmnl"
PKG_LONGDESC="Tool to administer IP sets."

PKG_BUILD_FLAGS="-sysroot"
PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static"