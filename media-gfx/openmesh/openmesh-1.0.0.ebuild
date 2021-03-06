# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/openmesh/openmesh-1.0.0.ebuild,v 1.6 2009/06/25 18:04:10 yngwin Exp $

EAPI="1"
inherit eutils

MY_PN="OpenMesh"
MY_P=${MY_PN}_${PV}
S=${WORKDIR}/${MY_PN}
DESCRIPTION="A generic and efficient data structure for representing and manipulating polygonal meshes"
HOMEPAGE="http://www.openmesh.org/"
SRC_URI="http://www-i8.informatik.rwth-aachen.de/${MY_PN}/downloads/${MY_P}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="qt4 debug"

RDEPEND="qt4? ( x11-libs/qt-gui:4 )"
DEPEND="dev-util/acgmake
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gcc41.patch || die

	if ! use qt4
	then
		sed -i "s:Apps::" ACGMakefile
	fi

	find . -name 'CVS' -type d -print0 | xargs -0 rm -rf
}

src_compile() {
	use debug && myconf="-dbg"
	acgmake ${myconf} || die

	# fix insecure runpaths
	TMPDIR=${S} scanelf -BXRr "${S}" -o /dev/null || die
}

src_install() {
	local l

	for l in $(find "${S}"/{Core,Tools} -name '*.so'); do
		dolib ${l} || die
	done

	make clean

	find . -name 'ACGMakefile' -delete
	find . -name '*.vcproj' -delete

	dodir /usr/include/${MY_PN}

	cp -a Core "${D}"/usr/include/${MY_PN}
	cp -a Tools "${D}"/usr/include/${MY_PN}
}
