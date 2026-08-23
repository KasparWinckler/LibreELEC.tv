PKG_NAME="zerotier-one"
PKG_VERSION="1.16.2"
PKG_SHA256="2c607f573c6e38815433af289d364a689a203b18b51125f06c4472014d0657f0"
PKG_REV="1"
PKG_LICENSE="BSL1.1"
PKG_SITE="https://www.zerotier.com/"
PKG_URL="https://github.com/zerotier/ZeroTierOne/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host openssl"
PKG_TOOLCHAIN="make"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="ZeroTier One"
PKG_ADDON_TYPE="xbmc.service"
PKG_SECTION="service"
PKG_SHORTDESC="${PKG_ADDON_NAME}: a smart programmable Ethernet switch for planet Earth"
PKG_LONGDESC="${PKG_ADDON_NAME} (${PKG_VERSION}) is a smart programmable Ethernet switch for planet Earth. It allows all networked devices, VMs, containers, and applications to communicate as if they all reside in the same physical data center or cloud region."

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
