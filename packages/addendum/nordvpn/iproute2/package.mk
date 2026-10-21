PKG_NAME="iproute2"
PKG_VERSION="7.3.0"
PKG_SHA256="154088d6af9624dd0c864b029623503bb590c4901cb0a721d48a08a388ee97a5"
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
