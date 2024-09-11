PKG_NAME="zerotier-one"
PKG_VERSION="1.14.1"
PKG_SHA256="4f9f40b27c5a78389ed3f3216c850921f6298749e5819e9f2edabb2672ce9ca0"
PKG_REV="4"
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
  export CFLAGS="--target=${TARGET_NAME} --sysroot=${SYSROOT_PREFIX}"
  export CXXFLAGS="${CFLAGS}"
  export INCLUDES="-I.${TARGET_NAME}/target"
  export TARGET_NAME
  export ZT_CARGO_FLAGS="--target ${TARGET_NAME}"
  cd ..
}

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin.private
    cp -PR ${PKG_INSTALL}/usr/sbin/zerotier-one \
           ${ADDON_BUILD}/${PKG_ADDON_ID}/bin.private
}
