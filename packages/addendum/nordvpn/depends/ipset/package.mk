PKG_NAME="ipset"
PKG_VERSION="7.21"
PKG_SHA256="e2c6ce4fcf3acb3893ca5d35c86935f80ad76fc5ccae601185842df760e0bc69"
PKG_LICENSE="GPLv2"
PKG_SITE="https://ipset.netfilter.org/"
PKG_URL="https://ipset.netfilter.org/ipset-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libmnl"
PKG_LONGDESC="Tool to administer IP sets."

PKG_BUILD_FLAGS="-sysroot"
PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static"