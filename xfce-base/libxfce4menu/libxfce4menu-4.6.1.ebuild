# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfce4menu/libxfce4menu-4.6.1.ebuild,v 1.18 2010/03/31 12:22:18 ssuominen Exp $

EAPI=3
inherit xfconf

DESCRIPTION="a freedesktop.org compliant menu library for Xfce4"
HOMEPAGE="http://www.xfce.org/projects/libraries"

LICENSE="LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.6:2
	>=xfce-base/libxfce4util-4.6"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	dev-util/pkgconfig"

RESTRICT="test"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		--disable-static
		$(xfconf_use_debug)
		--with-html-dir=${EPREFIX}/usr/share/doc/${PF}/html"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}
