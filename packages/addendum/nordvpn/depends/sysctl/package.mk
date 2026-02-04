PKG_NAME="sysctl"
PKG_VERSION="4.0.6"
PKG_SHA256="144410bd111330b191d4384ba6e8b4861390c644b7188e9487f779116b35a33c"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/procps-ng/procps"
PKG_URL="https://gitlab.com/procps-ng/procps/-/archive/v${PKG_VERSION}/procps-v${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_LONGDESC="sysctl is used to modify kernel parameters at runtime."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-shared \
                           --enable-static"

PKG_MAKE_OPTS_TARGET="src/sysctl"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp ${PKG_BUILD}/.${TARGET_NAME}/src/sysctl \
       ${INSTALL}/usr/bin
}
