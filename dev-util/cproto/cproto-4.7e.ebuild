# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cproto/cproto-4.7e.ebuild,v 1.8 2010/01/15 21:25:05 fauli Exp $

MY_PV="4_7e"
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Generate C function prototypes from C source code"
HOMEPAGE="http://invisible-island.net/cproto/"
SRC_URI="ftp://invisible-island.net/cproto/${MY_P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_install() {
	dobin cproto || die
	doman cproto.1
	dodoc README CHANGES
}
