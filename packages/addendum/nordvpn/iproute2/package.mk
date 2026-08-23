PKG_NAME="iproute2"
PKG_VERSION="7.2.0"
PKG_SHA256="30700923d57f05fa633065f89291ee49c6a8911a9578478c62eaf125470fbd22"
PKG_LICENSE="GPLv2"
PKG_SITE="https://wiki.linuxfoundation.org/networking/iproute2"
PKG_URL="https://github.com/iproute2/iproute2/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A set of utilities for Linux networking."

PKG_BUILD_FLAGS="-sysroot"
PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static"

pre_configure_target() {
  export LDFLAGS="${LDFLAGS} -pthread"
  cd ..
}
