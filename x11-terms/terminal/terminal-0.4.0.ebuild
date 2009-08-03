# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/terminal/terminal-0.4.0.ebuild,v 1.1 2009/08/02 17:31:00 darkside Exp $

EAPI="2"
inherit xfconf

MY_P=${P/t/T}

DESCRIPTION="Terminal for Xfce desktop environment, based on vte library."
HOMEPAGE="http://www.xfce.org/projects/terminal"
SRC_URI="mirror://xfce/src/apps/terminal/0.4/Terminal-0.4.0.tar.bz2 -> terminal-0.4.0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dbus debug doc nls"

RDEPEND=">=dev-libs/glib-2.6:2
	media-libs/fontconfig
	media-libs/freetype:2
	>=x11-libs/gtk+-2.6:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/vte
	>=xfce-extra/exo-0.3.4
	x11-libs/startup-notification
	dbus? ( dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	doc? ( dev-libs/libxslt )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	XFCONF="--disable-dependency-tracking $(use_enable dbus)
		$(use_enable debug)
		$(use_enable doc xsltproc)
		$(use_enable nls)"

	DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"
}
