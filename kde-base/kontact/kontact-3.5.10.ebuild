# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontact/kontact-3.5.10.ebuild,v 1.1 2008/09/13 23:59:19 carlo Exp $

KMNAME=kdepim
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE personal information manager"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=kde-base/libkdepim-${PV}:${SLOT}
		>=kde-base/libkpimidentities-${PV}:${SLOT}"

RDEPEND="${DEPEND}"

KMCOPYLIB="libkdepim libkdepim/
	libkpimidentities.la libkpimidentities/"
KMEXTRACTONLY="libkdepim/
	libkpimidentities/
	kontact/plugins/"
KMEXTRA="
	kontact/plugins/newsticker/
	kontact/plugins/summary/
	kontact/plugins/weather/"
# We remove some plugins that are related to external kdepim programs,
# because they also need libs from korganizer, kpilot etc... so to emerge
# kontact we'd also need ALL the other programs, thus, it's better to emerge
# kontact's plugins in the ebuild of its program.

pkg_postinst() {
	kde_pkg_postinst

	elog "If you're using x11-misc/basket, please re-emerge it now to avoid crashes with ${PN}."
	elog "cf. https://bugs.gentoo.org/show_bug.cgi?id=174872 for details."
}