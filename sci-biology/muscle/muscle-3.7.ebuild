# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/muscle/muscle-3.7.ebuild,v 1.1 2008/03/21 21:23:44 dberkholz Exp $

inherit toolchain-funcs

MY_P="${PN}${PV}_src"
DESCRIPTION="Multiple sequence comparison by log-expectation"
HOMEPAGE="http://www.drive5.com/muscle/"
SRC_URI="http://www.drive5.com/muscle/downloads${PV}/${MY_P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	sed -i \
		"s:-static::g" \
		"${S}/Makefile"
	sed -i \
		"/strip/d" \
		"${S}/Makefile"
}

src_compile() {
	emake \
		GPP="$(tc-getCXX)" \
		CFLAGS="${CXXFLAGS}" \
		|| die "make failed"
}

src_install() {
	DESTTREE="/usr" dobin muscle
}
