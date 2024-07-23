PKG_NAME="nordvpn"
PKG_VERSION="3.18.3"
PKG_SHA256="37e6383e93326bca6bff4eaac1089c42c58a641db55d26da63e7de0f47b0d4a8"
PKG_REV="3"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://nordvpn.com/"
PKG_URL="https://github.com/NordSecurity/nordvpn-linux/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cargo:host go:host iproute2 ipset libxml2 sysctl"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_SECTION="service"
PKG_ADDON_NAME="NordVPN"
PKG_ADDON_TYPE="service.nordvpn"
PKG_ADDON_PROVIDES="executable"
PKG_SHORTDESC="The NordVPN Linux application"
PKG_LONGDESC="The NordVPN Linux application (${PKG_VERSION}) provides a simple and user-friendly command line interface for accessing all the different features of NordVPN. Users can choose from a list of server locations around the world, or let the application automatically select the best server for them. They can also customize their connection settings, such as choosing a specific protocol or enabling the kill switch"

configure_target() {
  go_configure
  export LDFLAGS="-w -linkmode external -extldflags -Wl,--unresolved-symbols=ignore-in-shared-libs,-L.${TARGET_NAME}/target/${TARGET_NAME}/release,-lfoss -extld ${CC} \
                  -X main.Environment=prod \
                  -X main.Hash=${PKG_SHA256} \
                  -X main.Salt=${NORDVPN_SALT:?Pass me the NORDVPN_SALT} \
                  -X main.Version=${PKG_VERSION}"
  export RUSTC_LINKER=${CC}

  # build/foss variables
  export ENVIRONMENT="prod"
  export REVISION=1
  export VERSION=${PKG_VERSION}

  # gokogiri could not determine kind of name for C.free
  ${GOLANG} mod edit -replace github.com/jbowtie/gokogiri=github.com/KasparWinckler/gokogiri@b026747eeb5eef30800ef348cb23094c24812ebc
  ${GOLANG} mod tidy
}

make_target() {
  cd build/foss
    cargo build --target ${TARGET_NAME} --release
    cd -
  ${GOLANG} build -a -ldflags "${LDFLAGS}" -o bin/nordvpn ./cmd/cli
  ${GOLANG} build -a -ldflags "${LDFLAGS}" -buildmode=pie -tags=drop,telio -o bin/nordvpnd ./cmd/daemon
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp ${PKG_BUILD}/bin/* \
	   ${INSTALL}/usr/bin
}

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
    cp ${PKG_INSTALL}/usr/bin/nordvpn \
       ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/sbin
    cp ${PKG_INSTALL}/usr/bin/nordvpnd \
	     $(get_install_dir iproute2)/sbin/ip \
	     $(get_install_dir ipset)/usr/sbin/ipset \
	     $(get_install_dir sysctl)/usr/bin/sysctl \
	     ${ADDON_BUILD}/${PKG_ADDON_ID}/sbin
}
