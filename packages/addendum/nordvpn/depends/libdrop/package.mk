PKG_NAME="libdrop"
PKG_VERSION="7.0.0"
PKG_SHA256="b763c63e6d6075604f89289ea28c320a064559666749f803759f30b601f3e473"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/NordSecurity/libdrop"
PKG_URL="https://github.com/NordSecurity/libdrop/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host"
PKG_LONGDESC="libdrop"
PKG_TOOLCHAIN="manual"

make_target() {
  cargo build --target ${TARGET_NAME} --release
  ${STRIP} .${TARGET_NAME}/target/${TARGET_NAME}/release/libnorddrop.so -o libnorddrop.so
}
