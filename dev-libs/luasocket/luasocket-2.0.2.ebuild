# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/luasocket/luasocket-2.0.2.ebuild,v 1.1 2009/09/28 10:54:29 flameeyes Exp $

EAPI=2

inherit multilib toolchain-funcs flag-o-matic eutils

DESCRIPTION="Networking support library for the Lua language."
HOMEPAGE="http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/"
SRC_URI="http://luaforge.net/frs/download.php/2664/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-lang/lua-5.1[deprecated]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# Unix socket support is needed by app-crypt/ekeyd, but upstream
	# does not seem to enable it by default.
	epatch "${FILESDIR}"/${P}-unixsocket.patch
}

src_compile() {
	# We append flags here to avoid editing the config file
	use debug && append-flags -DLUASOCKET_DEBUG
	append-flags -fPIC

	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared" \
		|| die
}

src_install() {
	emake install \
		INSTALL_TOP_SHARE="${D}/$(pkg-config --variable INSTALL_LMOD lua)" \
		INSTALL_TOP_LIB="${D}/$(pkg-config --variable INSTALL_CMOD lua | sed -e "s:lib/:$(get_libdir)/:")" \
		|| die

	dodoc NEW README || die
	dohtml doc/* || die
}
