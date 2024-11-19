PKG_NAME="libdrop"
PKG_VERSION="8.1.1"
PKG_SHA256="a64a341e985525b93264f0468b4d4075354eeeafc868339fd7571887dc6a324c"
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
