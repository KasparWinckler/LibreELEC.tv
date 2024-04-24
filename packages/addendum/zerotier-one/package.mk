PKG_NAME="zerotier-one"
PKG_VERSION="1.12.2"
PKG_SHA256="7c6512cfc208374ea9dc9931110e35f71800c34890e0f35991ea485aae66e31c"
PKG_REV="0"
PKG_LICENSE="BSL1.1"
PKG_SITE="https://www.zerotier.com/"
PKG_URL="https://github.com/zerotier/ZeroTierOne/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host openssl"
PKG_TOOLCHAIN="make"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="ZeroTier One"
PKG_ADDON_TYPE="xbmc.service"
PKG_SECTION="service"
PKG_SHORTDESC="${PKG_ADDON_NAME}: securely connect any device, anywhere"
PKG_LONGDESC="${PKG_ADDON_NAME} (${PKG_VERSION}) lets you build modern, secure multi-point virtualized networks of almost any type. From robust peer-to-peer networking to multi-cloud mesh infrastructure, we enable global connectivity with the simplicity of a local network."

pre_make_target() {
  export CC="clang"
  export CXX="clang++"
  export CFLAGS="--target=${TARGET_NAME} --sysroot=${SYSROOT_PREFIX} ${CFLAGS//-mabi=lp64/}"
  export CXXFLAGS="${CFLAGS}"
  export TARGET_NAME
  cd ..
}

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin.private
    cp -PR ${PKG_INSTALL}/usr/sbin/zerotier-one \
           ${ADDON_BUILD}/${PKG_ADDON_ID}/bin.private
}
