# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/starparse/starparse-0.9.ebuild,v 1.3 2009/07/08 09:45:41 fauli Exp $

if [[ ${PV} = 9999* ]]; then
	EBZR_REPO_URI="http://oregonstate.edu/~benisong/software/projects/starparse/releases/0.9"
	EBZR_BOOTSTRAP="eautoreconf"
	BZR="bzr"
fi

inherit autotools ${BZR}

DESCRIPTION="Library for parsing NMR star files (peak-list format) and CIF files"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
SRC_URI="mirror://sourceforge/burrow-owl/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="guile"
RDEPEND="guile? ( dev-scheme/guile )"
DEPEND="${RDEPEND}"

src_compile() {
	econf $(use_enable guile) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
