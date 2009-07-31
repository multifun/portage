# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/tome/tome-2.3.5.ebuild,v 1.2 2009/07/31 13:51:20 nyhm Exp $

inherit eutils games

MY_PV=${PV//./}
DESCRIPTION="save the world from Morgoth and battle evil (or become evil ;])"
HOMEPAGE="http://t-o-m-e.net/"
SRC_URI="http://t-o-m-e.net/dl/src/tome-${MY_PV}-src.tar.bz2"

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="X Xaw3d gtk sdl"

RDEPEND=">=sys-libs/ncurses-5
	X? ( x11-libs/libX11 )
	Xaw3d? ( x11-libs/libXaw )
	sdl? (
		media-libs/sdl-ttf
		media-libs/sdl-image
		media-libs/libsdl )
	gtk? ( >=x11-libs/gtk+-2.12.8 ) "
DEPEND="${RDEPEND}
	x11-misc/makedepend"

S=${WORKDIR}/tome-${MY_PV}-src

src_unpack() {
	unpack ${A}
	cd "${S}"
	cd "src"
	mv makefile.std makefile
	epatch "${FILESDIR}/${PV}-gentoo-paths.patch"
	sed -i \
		-e "s:GENTOO_DIR:${GAMES_STATEDIR}:" files.c init2.c \
		|| die "sed failed"

	find "${S}" -name .cvsignore -exec rm -f \{\} \;
	find "${S}/lib/edit" -type f -exec chmod a-x \{\} \;
}

src_compile() {
	local GENTOO_INCLUDES="" GENTOO_DEFINES="-DUSE_GCU " GENTOO_LIBS="-lncurses"
	if use sdl || use X || use gtk || use Xaw3d; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_EGO_GRAPHICS -DUSE_TRANSPARENCY \
			-DSUPPORT_GAMMA"
	fi
	if use sdl || use X || use Xaw3d; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_PRECISE_CMOVIE -DUSE_UNIXSOCK "
	fi
	if use sdl; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} $(sdl-config --cflags)"
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_SDL "
		GENTOO_LIBS="${GENTOO_LIBS} $(sdl-config --libs) -lSDL_image -lSDL_ttf"
	fi
	if use X; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} -I/usr/X11R6/include "
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_X11 "
		GENTOO_LIBS="${GENTOO_LIBS} -L/usr/X11R6/lib -lX11 "
	fi
	if use Xaw3d; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} -I/usr/X11R6/include "
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_XAW "
		GENTOO_LIBS="${GENTOO_LIBS} -L/usr/X11R6/lib -lXaw -lXmu -lXt -lX11 "
	fi
	if use gtk; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} $(pkg-config gtk+-2.0 --cflags)"
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_GTK2 "
		GENTOO_LIBS="${GENTOO_LIBS} $(pkg-config gtk+-2.0 --libs) "
		GTK_SRC_FILE="main-gtk2.c"
		GTK_OBJ_FILE="main-gtk2.o"
	else
		GTK_SRC_FILE=""
		GTK_OBJ_FILE=""
	fi
	if use amd64; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DLUA_NUM_TYPE=int "
	fi
	GENTOO_INCLUDES="${GENTOO_INCLUDES} -Ilua -I."
	GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_LUA"
	cd src
	make \
		INCLUDES="${GENTOO_INCLUDES}" \
		DEFINES="${GENTOO_DEFINES}" \
		depend || die "make depend failed"
	emake ./tolua || die "emake ./tolua failed"
	emake \
		COPTS="${CFLAGS}" \
		INCLUDES="${GENTOO_INCLUDES}" \
		DEFINES="${GENTOO_DEFINES}" \
		LIBS="${GENTOO_LIBS}" \
		BINDIR="${GAMES_BINDIR}" \
		LIBDIR="${GAMES_DATADIR}/${PN}" \
		GTK_SRC_FILE="${GTK_SRC_FILE}" \
		GTK_OBJ_FILE="${GTK_OBJ_FILE}" \
		|| die "emake failed"
}

src_install() {
	cd src
	make \
		DESTDIR="${D}" \
		OWNER="${GAMES_USER}" \
		BINDIR="${GAMES_BINDIR}" \
		LIBDIR="${GAMES_DATADIR}/${PN}" install \
		|| die "make install failed"
	cd "${S}"
	dodoc *.txt

	dodir "${GAMES_STATEDIR}"
	touch "${D}/${GAMES_STATEDIR}/${PN}-scores.raw"
	prepgamesdirs
	fperms g+w "${GAMES_STATEDIR}/${PN}-scores.raw"
	#FIXME: something has to be done about this.
	fperms g+w "${GAMES_DATADIR}/${PN}/data"
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "ToME ${PV} is not save-game compatible with 2.3.0 and previous versions."
	echo
	ewarn "If you have older save files and you wish to continue those games,"
	ewarn "you'll need to remerge the version of ToME with which you started"
	ewarn "those save-games."
}
