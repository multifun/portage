# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/gmap/gmap-2010.03.09.ebuild,v 1.1 2010/03/23 07:31:07 weaver Exp $

EAPI="2"

MY_PV=${PV//./-}

DESCRIPTION="A Genomic Mapping and Alignment Program for mRNA and EST Sequences"
HOMEPAGE="http://www.gene.com/share/gmap/"
SRC_URI="http://www.gene.com/share/gmap/src/gmap-gsnap-${MY_PV}.tar.gz"

LICENSE="gmap"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/gmap-${MY_PV}"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog README
}
