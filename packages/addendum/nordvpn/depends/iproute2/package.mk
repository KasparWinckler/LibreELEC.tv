PKG_NAME="iproute2"
PKG_VERSION="6.18.0"
PKG_SHA256="92c97e3d47a9d4faf9ee3016bc1145471474ebabbbf20962a51d3a7d0d82e321"
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
