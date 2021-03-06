# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vboxgtk/vboxgtk-0.5.0.ebuild,v 1.1 2009/10/12 18:43:39 volkmar Exp $

EAPI="2"

inherit gnome2-utils distutils

DESCRIPTION="GTK frontend for VirtualBox"
HOMEPAGE="http://vboxgtk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="linguas_es"

DEPEND=""
RDEPEND="
	|| ( >=app-emulation/virtualbox-ose-2.2.2[-headless,sdk]
		>=app-emulation/virtualbox-bin-2.2.2 )
	>=dev-python/pygtk-2.14.0"

src_prepare() {
	if ! use linguas_es; then
		rm po/es.po || die "rm failed"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
