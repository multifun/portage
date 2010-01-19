# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ibm-powerpc-utils/ibm-powerpc-utils-1.1.2.ebuild,v 1.2 2010/01/18 14:51:22 ranger Exp $

inherit eutils

MY_P="powerpc-utils-${PV}"

DESCRIPTION="This package provides utilities for the maintainance
of the IBM and Apple powerpc platforms."
SRC_URI="http://powerpc-utils.ozlabs.org/releases/${MY_P}.tar.gz"
HOMEPAGE="http://powerpc-utils.ozlabs.org/"

S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"
IUSE=""
DEPEND=">=sys-libs/librtas-1.3.1
sys-devel/bc"
RDEPEND="!sys-apps/ppc64-utils"

src_unpack() {
	unpack ${A}
}

src_install() {
	make DESTDIR="${D}" install || die "Something went wrong"

}

pkg_postinst() {
	einfo "If you are running IBM hardware, consider emerging "
	einfo "sys-apps/ibm-powerpc-utils-papr for additional functions. "
}
