# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/enet/enet-1.0.ebuild,v 1.5 2007/07/05 20:03:20 corsair Exp $

DESCRIPTION="relatively thin, simple and robust network communication layer on top of UDP"
HOMEPAGE="http://enet.bespin.org/"
SRC_URI="http://enet.bespin.org/download/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ppc ~ppc64 x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc *.txt README
}
