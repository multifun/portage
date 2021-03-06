# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mtail/mtail-1.1.1-r1.ebuild,v 1.16 2010/01/01 21:19:24 fauli Exp $

inherit eutils

DESCRIPTION="tail workalike, that performs output colourising"
HOMEPAGE="http://matt.immute.net/src/mtail/"
SRC_URI="http://matt.immute.net/src/mtail/mtail-${PV}.tgz
	http://matt.immute.net/src/mtail/mtailrc-syslog.sample"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 mips ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/python"

src_unpack() {
	unpack ${P}.tgz
	cd "${S}"
	epatch "${FILESDIR}"/${P}-remove-blanks.patch
}

src_install() {
	dobin mtail || die
	dodoc CHANGES mtailrc.sample README "${DISTDIR}"/mtailrc-syslog.sample
}
