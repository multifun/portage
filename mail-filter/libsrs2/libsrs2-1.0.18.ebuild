# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/libsrs2/libsrs2-1.0.18.ebuild,v 1.6 2010/02/01 20:00:59 maekke Exp $

inherit eutils autotools

DESCRIPTION="libsrs2 is the next generation Sender Rewriting Scheme library"
HOMEPAGE="http://www.libsrs2.org/"
SRC_URI="http://www.libsrs2.org/srs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-parallel-make.diff"
	eautoreconf
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	find "${D}" -name '*.la' -delete
	dodoc AUTHORS INSTALL NEWS README
}
