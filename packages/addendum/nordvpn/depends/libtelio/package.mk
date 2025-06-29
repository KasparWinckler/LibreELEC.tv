PKG_NAME="libtelio"
PKG_VERSION="5.4.0"
PKG_SHA256="a4a8e7fee5e32f5bc0deed7fa0e6cca320993c65aada127e91ed98ed13c04da1"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/NordSecurity/libtelio"
PKG_URL="https://github.com/NordSecurity/libtelio/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host"
PKG_LONGDESC="libtelio"
PKG_TOOLCHAIN="manual"

configure_target() {
  cargo update home@0.5.11 --precise 0.5.9
}

make_target() {
  BYPASS_LLT_SECRETS=1 cargo build --target ${TARGET_NAME} --release
  ${STRIP} .${TARGET_NAME}/target/${TARGET_NAME}/release/libtelio.so -o libtelio.so
}
