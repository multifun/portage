# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fnlib/fnlib-0.5-r1.ebuild,v 1.27 2009/09/23 15:13:41 ssuominen Exp $

DESCRIPTION="Font Library"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"
IUSE=""

DEPEND="media-libs/imlib"

src_compile() {
	econf --sysconfdir=/etc/fnlib || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog HACKING NEWS README
	dodoc doc/fontinfo.README
}
