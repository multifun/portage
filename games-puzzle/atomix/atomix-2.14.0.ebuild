# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/atomix/atomix-2.14.0.ebuild,v 1.5 2008/03/07 16:54:08 wolf31o2 Exp $

inherit gnome2

DESCRIPTION="a game where you build full molecules, from simple inorganic to extremely complex organic ones"
HOMEPAGE="http://ftp.gnome.org/pub/GNOME/sources/atomix/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=x11-libs/pango-1.0.3
	>=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.6
	>=gnome-base/gconf-2.12
	>=gnome-base/libglade-2.4
	>=gnome-base/libgnome-2.12
	>=gnome-base/libgnomeui-2.12
	>=gnome-base/libbonoboui-2.0.0
	>=gnome-base/libgnomecanvas-2.0.0
	>=dev-libs/libxml2-2.4.23
	dev-perl/XML-Parser"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.17"

DOCS="AUTHORS ChangeLog NEWS README"
