# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-common/gnome-common-2.24.0.ebuild,v 1.12 2009/05/10 18:15:06 eva Exp $

inherit gnome2

DESCRIPTION="Common files for development of Gnome packages"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="ChangeLog README* doc/usage.txt"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv doc-build/README README.doc-build
}
