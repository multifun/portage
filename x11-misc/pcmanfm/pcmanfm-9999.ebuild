# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pcmanfm/pcmanfm-9999.ebuild,v 1.1 2010/06/22 09:22:10 hwoarang Exp $

EAPI="2"

inherit autotools eutils fdo-mime git

DESCRIPTION="Fast lightweight tabbed filemanager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
EGIT_REPO_URI="git://pcmanfm.git.sourceforge.net/gitroot/pcmanfm/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug hal udev"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2
	gnome-base/gnome-mount
	gnome-base/gvfs[hal?,udev?]
	lxde-base/menu-cache
	x11-misc/shared-mime-info
	x11-libs/libfm"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	# add missing files to traslation file. Fixes tests
	for i in about.ui autorun.ui desktop-pref.ui pref.ui; do
		echo "data/ui/${i}" >> po/POTFILES.in
	done
	eautoreconf
	einfo "Running intltoolize ..."
	intltoolize --force --copy --automake || die
	strip-linguas -i "${S}/po"
}

src_configure() {
	econf --sysconfdir=/etc $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	elog 'PCmanFM can optionally support the menu://applications/ location.'
	elog 'You should install lxde-base/lxmenu-data for that	functionality.'
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
