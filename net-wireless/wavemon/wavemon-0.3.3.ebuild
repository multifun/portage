# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wavemon/wavemon-0.3.3.ebuild,v 1.9 2006/06/07 21:50:58 brix Exp $

DESCRIPTION="ncurses based monitor util for your wavelan cards"
SRC_URI="http://www.jm-music.de/wavemon-current.tar.gz"
HOMEPAGE="http://www.janmorgenstern.de/projects-software.html"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND="sys-libs/ncurses"

src_install() {
	dodir /usr/bin /usr/share/man/{man1,man5}
	make prefix="${D}/usr" mandir="${D}/usr/share/man" install
	dodoc README TODO COPYING AUTHORS
}
