# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/drkonqi/drkonqi-4.3.5.ebuild,v 1.5 2010/06/21 15:53:48 scarabeus Exp $

EAPI="2"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="KDE crash handler, gives the user feedback if a program crashed"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

add_blocker drkonqi2

pkg_postinst() {
	kde4-meta_pkg_postinst
	if ! has_version "sys-devel/gdb"; then
		elog "For more usability consider installing following packages:"
	elog "    sys-devel/gdb - Easier debugging support"
	fi
}
