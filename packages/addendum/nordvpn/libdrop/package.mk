PKG_NAME="libdrop"
PKG_VERSION="9.0.0"
PKG_SHA256="e812c05a037e7255f6b7a3eda356ef651218c662351bc7958926e793a2d8a732"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/NordSecurity/libdrop"
PKG_URL="https://github.com/NordSecurity/libdrop/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host sqlite"
PKG_LONGDESC="libdrop"
PKG_TOOLCHAIN="manual"

make_target() {
  cargo build --target ${TARGET_NAME} --release
  ${STRIP} .${TARGET_NAME}/target/${TARGET_NAME}/release/libnorddrop.so -o libnorddrop.so
}
