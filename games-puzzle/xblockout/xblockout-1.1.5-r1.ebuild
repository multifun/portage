# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/xblockout/xblockout-1.1.5-r1.ebuild,v 1.1 2008/10/27 22:42:20 tupone Exp $

inherit flag-o-matic eutils games

DESCRIPTION="X Window block dropping game in 3 Dimension"
HOMEPAGE="http://www710.univ-lyon1.fr/ftp/xbl/xbl.html"
SRC_URI="http://www710.univ-lyon1.fr/~exco/XBL/xbl-${PV}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/libXext"

S=${WORKDIR}/xbl-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-font.patch

	sed -i \
		-e 's:-lm:-lm -lX11:' \
		-e '/DGROUP_GID/d' \
		-e "s:-g$:${CFLAGS}:" \
		Makefile.in || die "sed failed"
}

src_compile() {
	# Don't know about other archs. --slarti
	use amd64 && filter-flags "-fweb"

	egamesconf || die
	emake \
		USE_SETGID= \
		SCOREDIR="${GAMES_DATADIR}/${PN}" \
		RESOURCEDIR="${GAMES_DATADIR}/${PN}" \
		|| die "emake failed"
}

src_install() {
	newgamesbin bl xbl || die "newgamesbin failed"

	insinto "${GAMES_DATADIR}"/${PN}
	newins Xbl.ad Xbl || die "doins failed"

	newman xbl.man xbl.6
	dodoc README xbl-README
	dohtml *.html *.gif

	prepgamesdirs
}