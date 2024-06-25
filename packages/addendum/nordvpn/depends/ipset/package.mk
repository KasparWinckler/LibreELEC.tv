PKG_NAME="ipset"
PKG_VERSION="7.22"
PKG_SHA256="f6ac5a47c3ef9f4c67fcbdf55e791cbfe38eb0a4aa1baacd12646a140abacdd9"
PKG_LICENSE="GPLv2"
PKG_SITE="https://ipset.netfilter.org/"
PKG_URL="https://ipset.netfilter.org/ipset-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libmnl"
PKG_LONGDESC="Tool to administer IP sets."

PKG_BUILD_FLAGS="-sysroot"
PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static"