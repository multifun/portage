# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-gnome/bluez-gnome-1.8.ebuild,v 1.8 2010/01/14 01:28:55 jer Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Bluetooth helpers for GNOME"
HOMEPAGE="http://www.bluez.org/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86"

IUSE="gnome"
COMMON_DEPEND="dev-libs/glib:2
	>=x11-libs/libnotify-0.3.2
	>=gnome-base/gconf-2.6
	>=dev-libs/dbus-glib-0.60
	sys-apps/hal
	>=x11-libs/gtk+-2.6"
DEPEND="
	dev-util/pkgconfig
	x11-proto/xproto
	${COMMON_DEPEND}"
RDEPEND="net-wireless/bluez
	gnome? ( gnome-base/nautilus gnome-base/gvfs[bluetooth] )
	>=app-mobilephone/obex-data-server-0.4
	${COMMON_DEPEND}"

G2CONF="--disable-desktop-update
		--disable-mime-update
		--disable-icon-update"

DOCS="AUTHORS README NEWS ChangeLog"

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}/${PV}-ODS-API.patch"
}
