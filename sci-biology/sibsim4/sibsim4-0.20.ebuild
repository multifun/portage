# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/sibsim4/sibsim4-0.20.ebuild,v 1.1 2010/05/05 06:54:08 weaver Exp $

EAPI="2"

DESCRIPTION="A rewrite and improvement upon sim4, a DNA-mRNA aligner"
HOMEPAGE="http://sibsim4.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/SIBsim4-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/SIBsim4-${PV}"

src_prepare() {
	sed -i 's/CFLAGS = \(.*\)/CFLAGS := \1 ${CFLAGS}/' "${S}/Makefile"
}

src_install() {
	dobin SIBsim4
	doman SIBsim4.1
}
