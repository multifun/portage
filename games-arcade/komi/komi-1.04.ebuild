# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/komi/komi-1.04.ebuild,v 1.5 2007/03/15 23:14:50 nyhm Exp $

inherit eutils games

DESCRIPTION="Komi the Space Frog - simple SDL game of collection"
HOMEPAGE="http://komi.sourceforge.net"
SRC_URI="mirror://sourceforge/komi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-DESTDIR.patch
	sed -i \
		-e "/^BINPATH/s:=.*:=${GAMES_BINDIR}/:" \
		-e "/^DATAPATH/s:=.*:=${GAMES_DATADIR}/${PN}/:" Makefile \
		|| die "sed failed"
}

src_compile() {
	emake ECFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon komidata/sprites_komi.bmp ${PN}.bmp
	make_desktop_entry komi Komi /usr/share/pixmaps/${PN}.bmp
	doman komi.6
	dodoc CHANGELOG.txt README.txt TROUBLESHOOTING.txt
	prepgamesdirs
}
