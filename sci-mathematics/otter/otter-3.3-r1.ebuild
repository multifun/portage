# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/otter/otter-3.3-r1.ebuild,v 1.7 2010/01/02 18:20:20 fauli Exp $

DESCRIPTION="An Automated Deduction System."
SRC_URI="http://www-unix.mcs.anl.gov/AR/${PN}/${P}.tar.gz"
HOMEPAGE="http://www-unix.mcs.anl.gov/AR/otter/"

KEYWORDS="~amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
LICENSE="otter"
SLOT="0"
IUSE=""
DEPEND="virtual/libc"

src_compile() {
	cd source
	emake -j1 || die
	cd "${S}"/mace2
	emake -j1 || die
}

src_install() {
	dobin bin/* source/formed/formed
	dodoc README* Legal Changelog Contents documents/*.{tex,ps}
	insinto /usr/share/doc/${PF}
	doins documents/*.pdf
	dohtml index.html
	insinto /usr/share/doc/${PF}/html
	doins -r examples examples-mace2
}
