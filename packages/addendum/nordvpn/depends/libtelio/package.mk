PKG_NAME="libtelio"
PKG_VERSION="5.1.9"
PKG_SHA256="7f9525b1ef79087bafc5d147656cb833445533065a2940f52efb8eee9faa6040"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/NordSecurity/libtelio"
#PKG_URL="https://github.com/NordSecurity/libtelio/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_URL="https://github.com/NordSecurity/libtelio/archive/6ad91929308cdf627eb8622bf98401c4df43d79f.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host"
PKG_LONGDESC="libtelio"
PKG_TOOLCHAIN="manual"

make_target() {
  BYPASS_LLT_SECRETS=1 cargo build --target ${TARGET_NAME} --release
  ${STRIP} .${TARGET_NAME}/target/${TARGET_NAME}/release/libtelio.so -o libtelio.so
}
