# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/xyscan/xyscan-3.2.1.ebuild,v 1.1 2009/07/22 23:47:31 bicatali Exp $

EAPI=2
inherit eutils qt4 versionator

MY_PV=$(replace_version_separator 2 '')

DESCRIPTION="Tool for extracting data points from graphs"
HOMEPAGE="http://star.physics.yale.edu/~ullrich/xyscanDistributionPage/"
SRC_URI="http://star.physics.yale.edu/~ullrich/${PN}DistributionPage/${MY_PV}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( x11-libs/qt-gui:4	>=x11-libs/qt-4.3:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i \
		-e "s:qApp->applicationDirPath() + \"/../docs\":\"/usr/share/doc/${PF}/html\":" \
		xyscanWindow.cpp || die "Failed to fix docs path"
}

src_configure() {
	eqmake4 xyscan.pro
}

src_install() {
	exeinto /usr/bin
	doexe xyscan || die "Failed to install xyscan"
	insinto /usr/share/doc/${PF}/html
	doins -r docs/* || die "Failed to install docs"
	newicon images/xyscanIcon.png xyscan.png
	make_desktop_entry xyscan "xyscan data point extractor"
}
