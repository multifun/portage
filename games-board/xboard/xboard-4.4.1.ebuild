# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/xboard/xboard-4.4.1.ebuild,v 1.8 2010/04/04 13:35:58 hwoarang Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="GUI for gnuchess and for internet chess servers"
HOMEPAGE="http://www.gnu.org/software/xboard/"
SRC_URI="mirror://gnu/xboard/${P}.tar.gz
	mirror://gentoo/${PN}.png
	http://dev.gentoo.org/~wolf31o2/sources/dump/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE="Xaw3d zippy"
RESTRICT="test" #124112

RDEPEND="Xaw3d? ( x11-libs/Xaw3d )
	x11-libs/libXpm
	x11-libs/libXaw
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXext
	x11-libs/libICE"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}*
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_with Xaw3d) \
		$(use_enable zippy)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYRIGHT ChangeLog NEWS README TODO ics-parsing.txt
	use zippy && dodoc zippy.README
	dohtml FAQ.html
	doicon "${DISTDIR}"/xboard.png
	make_desktop_entry ${PN} "Xboard (Chess)"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "No chess engines are emerged by default! If you want a chess engine"
	elog "to play with, you can emerge gnuchess or crafty."
	elog "Read xboard FAQ for information."
}
