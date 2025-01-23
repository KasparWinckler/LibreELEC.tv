PKG_NAME="libtelio"
PKG_VERSION="5.1.6"
PKG_SHA256="09bab5e32079d5b6314275df4e247ece9c57f7ee4db5a108ff89fd38c56fdb04"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/NordSecurity/libtelio"
PKG_URL="https://github.com/NordSecurity/libtelio/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host"
PKG_LONGDESC="libtelio"
PKG_TOOLCHAIN="manual"

make_target() {
  BYPASS_LLT_SECRETS=1 cargo build --target ${TARGET_NAME} --release
  ${STRIP} .${TARGET_NAME}/target/${TARGET_NAME}/release/libtelio.so -o libtelio.so
}
