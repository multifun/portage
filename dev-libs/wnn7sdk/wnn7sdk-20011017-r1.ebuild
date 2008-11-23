# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/wnn7sdk/wnn7sdk-20011017-r1.ebuild,v 1.1 2008/11/22 01:53:43 matsuu Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="Library and headers for Wnn7 client"
HOMEPAGE="http://www.omronsoft.co.jp/SP/pcunix/sdk/index.html"
SRC_URI="ftp://ftp.omronsoft.co.jp/pub/Wnn7/sdk_source/Wnn7SDK.tgz"

LICENSE="freedist"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# x11 is required for imake
DEPEND="x11-misc/imake"
RDEPEND=""

S="${WORKDIR}/src"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-malloc.patch"
	epatch "${FILESDIR}/${PN}-gentoo.patch"
	epatch "${FILESDIR}/${PN}-gcc4.patch"
	epatch "${FILESDIR}/${PN}-qa.patch"
	sed -i -e "/CONFIGSRC =/s:=.*:= /usr/$(get_libdir)/X11/config:" Makefile.ini || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		World -f Makefile.ini || die "make World failed"
}

src_install() {
	dolib.so Wnn/jlib/*.so* || die
	dolib.a  Wnn/jlib/*.a   || die

	insinto /usr/include/${PN}/wnn
	doins Wnn/include/*.h || die

	dodoc README
}