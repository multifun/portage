# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtecla/libtecla-1.6.1.ebuild,v 1.5 2009/09/23 17:24:10 patrick Exp $

inherit eutils

DESCRIPTION="Tecla command-line editing library"
HOMEPAGE="http://www.astro.caltech.edu/~mcs/tecla/"
SRC_URI="http://www.astro.caltech.edu/~mcs/tecla/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

IUSE=""
DEPEND="sys-libs/ncurses"

S=${WORKDIR}/libtecla

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-install.patch
	epatch "${FILESDIR}"/${P}-LDFLAGS.patch
	epatch "${FILESDIR}"/${P}-no-strip.patch

	# remove build directory from RPATH (see bug #119477)
	sed -e "s|:\$\$LD_RUN_PATH:\`pwd\`||" -i Makefile.rules || \
		die "Failed to adjust Makefile.rules"
}

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 install DESTDIR="${D}" || die "einstall failed"
	dodoc CHANGES INSTALL PORTING README RELEASE.NOTES
}
