PKG_NAME="sysctl"
PKG_VERSION="4.0.5"
PKG_SHA256="7e4b385e8f3e426089f3bb04e3bf150c710b875bd005474f034486b2379ce221"
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
