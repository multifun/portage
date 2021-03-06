# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-linelight-plugin/xfce4-linelight-plugin-0.1.6.ebuild,v 1.3 2010/01/15 03:17:00 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="a simple frontend for the locate search"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-linelight-plugin/"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.1/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=xfce-base/xfce4-panel-4.4
	>=xfce-base/libxfcegui4-4.4
	<xfce-base/thunar-1.1.0
	>=x11-libs/gtk+-2.12:2
	>=dev-libs/glib-2.16:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS"
	XFCONF="--disable-dependency-tracking"
}
