# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libev/libev-3.90-r1.ebuild,v 1.2 2010/05/31 18:27:32 gmsoft Exp $

inherit autotools eutils

MY_P="${P/0}"
DESCRIPTION="A high-performance event loop/event model with lots of feature"
HOMEPAGE="http://software.schmorp.de/pkg/libev.html"
SRC_URI="http://dist.schmorp.de/libev/${MY_P}.tar.gz
	http://dist.schmorp.de/libev/Attic/${MY_P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="elibc_glibc"

# Bug #283558
DEPEND="elibc_glibc? ( >=sys-libs/glibc-2.9_p20081201 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-3.42-gentoo.patch"

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc Changes README
}
