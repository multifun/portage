# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/tiemu/tiemu-3.03.ebuild,v 1.2 2009/11/09 11:12:26 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="Texas Instruments hand-helds emulator"
HOMEPAGE="http://lpg.ticalc.org/prj_tiemu/"
SRC_URI="http://repo.calcforge.org/debian/source/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus nls sdl threads xinerama"

RDEPEND="sci-libs/libticables2
	sci-libs/libticalcs2
	sci-libs/libtifiles2
	sci-libs/libticonv
	>=gnome-base/libglade-2.4.0
	>=x11-libs/gtk+-2.6.0
	dbus? ( >=dev-libs/dbus-glib-0.60 )
	nls? ( virtual/libintl )
	sdl? ( media-libs/libsdl )
	xinerama? ( x11-libs/libXinerama )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
	xinerama? ( x11-proto/xineramaproto )"

src_configure() {
	econf \
		--disable-rpath \
		--disable-debugger \
		--disable-gdb \
		$(use_enable nls) \
		$(use_enable sdl sound) \
		$(use_enable threads) \
		$(use_enable threads threading) \
		$(use_with dbus) \
		--without-kde \
		$(use_with xinerama)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}"usr/share/tiemu/{Manpage.txt,COPYING,RELEASE,AUTHORS,LICENSES}
	dodoc AUTHORS NEWS README README.linux RELEASE TODO
	make_desktop_entry tiemu "TiEmu Calculator" \
		/usr/share/tiemu/pixmaps/icon.xpm
}
