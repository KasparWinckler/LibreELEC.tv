PKG_NAME="ipset"
PKG_VERSION="7.24"
PKG_SHA256="fbe3424dff222c1cb5e5c34d38b64524b2217ce80226c14fdcbb13b29ea36112"
PKG_LICENSE="GPLv2"
PKG_SITE="https://ipset.netfilter.org/"
PKG_URL="https://ipset.netfilter.org/ipset-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libmnl"
PKG_LONGDESC="Tool to administer IP sets."

PKG_BUILD_FLAGS="-sysroot"
PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static"
