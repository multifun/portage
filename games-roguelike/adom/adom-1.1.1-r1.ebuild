# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/adom/adom-1.1.1-r1.ebuild,v 1.9 2006/06/23 00:14:20 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="Ancient Domains Of Mystery rogue-like game"
HOMEPAGE="http://www.adom.de/"
SRC_URI="http://www.adom.de/adom/download/linux/${P//.}-elf.tar.gz"

LICENSE="adom"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="strip" #bug #137340

DEPEND=">=sys-libs/ncurses-5.0
	amd64? ( app-emulation/emul-linux-x86-baselibs )"

S=${WORKDIR}/${PN}

src_install() {
	exeinto "${GAMES_PREFIX_OPT}/bin"
	doexe adom

	keepdir "${GAMES_STATEDIR}/${PN}"
	echo "${GAMES_STATEDIR}/${PN}" > adom_ds.cfg
	insinto /etc
	doins adom_ds.cfg

	edos2unix adomfaq.txt
	dodoc adomfaq.txt manual.doc readme.1st

	prepgamesdirs
	fperms g+w "${GAMES_STATEDIR}/${PN}"
}
