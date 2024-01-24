PKG_NAME="iproute2"
PKG_VERSION="6.7.0"
PKG_SHA256="182fbb0f4328c58b7199fb2abaade15cb47507f4e69bdae566252ff26e063d09"
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