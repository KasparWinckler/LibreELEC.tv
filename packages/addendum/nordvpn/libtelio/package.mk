PKG_NAME="libtelio"
PKG_VERSION="6.2.4"
PKG_SHA256="0377bcc252421eb2f33a09e0c368fe49a06cb4e4453b385f3f7e5c8b616d4708"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/NordSecurity/libtelio"
PKG_URL="https://github.com/NordSecurity/libtelio/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host"
PKG_LONGDESC="libtelio"
PKG_TOOLCHAIN="manual"

make_target() {
  # build of the crate aws-lc-sys fails when CMAKE is set. Set the required toolchain.
  unset CMAKE
  export CMAKE_TOOLCHAIN_FILE="${CMAKE_CONF}"
  export CMAKE_INSTALL_PREFIX="/usr"
  export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=${SYSROOT_PREFIX}"
  export RUSTC_LINKER=${CC}

  BYPASS_LLT_SECRETS=1 cargo build --target ${TARGET_NAME} --release
  ${STRIP} .${TARGET_NAME}/target/${TARGET_NAME}/release/libtelio.so -o libtelio.so
}
