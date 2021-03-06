# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/aurorae/aurorae-0.2.1.ebuild,v 1.2 2010/02/12 22:54:37 ssuominen Exp $

EAPI="2"

inherit kde4-base

DESCRIPTION="Aurorae Theme Engine for kde-4"
HOMEPAGE="http://www.kde-look.org/content/show.php/Aurorae+Theme+Engine?content=107158"
SRC_URI="http://kde-look.org/CONTENT/content-files/107158-${P}.tar.gz"

SLOT="4"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="<kde-base/kwin-4.4.0"
RDEPEND="${DEPEND}"

DOCS="theme-description"
S="${WORKDIR}/${PN}"

src_prepare() {
	kde4-base_src_prepare

	# workspace cmake fix
	sed -i \
		-e 's/${KDE4WORKSPACE_KDECORATIONS_LIBS}/kdecorations/g' \
		"${S}"/src/CMakeLists.txt || die "Patching failed!"
}
