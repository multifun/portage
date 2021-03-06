# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/bubble-chains/bubble-chains-0.1.0.ebuild,v 1.2 2010/04/05 07:47:21 phajdan.jr Exp $

EAPI=2
inherit eutils qt4 games

MY_P=${P/bubble-}-src

DESCRIPTION="Arcade-puzzle game"
HOMEPAGE="http://bubble-chains.sintegrial.com/"
SRC_URI="http://${PN}.sintegrial.com/files/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="x11-libs/libXrandr
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	media-libs/libsdl[audio,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e "s:/usr/local/bin:${GAMES_BINDIR}:g" \
		-e "s:/usr/local/games:${GAMES_DATADIR}:g" \
		-e "s:LIBS += -lSDLmain:LIBS += -lSDL:" \
		Game.pro gamewidget.cpp || die
}

src_configure() {
	eqmake4 Game.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die
	dodoc README
	newicon images/img64_base.png ${PN}.png
	make_desktop_entry chains "Bubble Chains"
	prepgamesdirs
}
