PKG_NAME="iproute2"
PKG_VERSION="6.16.0"
PKG_SHA256="2b90c310b371c6e0ab5d40effca0117acac775a431a97571f3ded13be3ffe5ee"
PKG_LICENSE="GPLv2"
PKG_SITE="https://wiki.linuxfoundation.org/networking/iproute2"
PKG_URL="https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A set of utilities for Linux networking."

PKG_BUILD_FLAGS="-sysroot"
PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static"

pre_configure_target() {
  export LDFLAGS="${LDFLAGS} -pthread"
  cd ..
}
