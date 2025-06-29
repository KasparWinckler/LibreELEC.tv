PKG_NAME="libdrop"
PKG_VERSION="8.2.4"
PKG_SHA256="3025ba70bf5b5aec5b1f6cde75f44c3f5130f11aa7b77b30fe02731761aa36b2"
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
