# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/vanessa-mcast/vanessa-mcast-1.0.0.ebuild,v 1.5 2009/09/23 18:51:16 patrick Exp $

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Multicast Helper Library"
HOMEPAGE="http://www.vergenet.net/linux/vanessa/"
SRC_URI="http://www.vergenet.net/linux/vanessa/download/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=dev-libs/vanessa-logger-0.0.6
	>=net-libs/vanessa-socket-0.0.7"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf || die "error configure"
	emake || die "error compiling"
}

src_install() {
	make DESTDIR=${D} install || die "error installing"
	dodoc README NEWS AUTHORS TODO INSTALL
}
