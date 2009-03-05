# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-wallpapers/kdeartwork-wallpapers-4.2.1.ebuild,v 1.1 2009/03/04 20:50:08 alexxy Exp $

EAPI="2"

RESTRICT="binchecks strip"

KMMODULE="wallpapers"
KMNAME="kdeartwork"
inherit kde4-meta

DESCRIPTION="Wallpapers from kde"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	!<kde-base/kde-wallpapers-$PV:${SLOT}[kdeprefix=]
	!kdeprefix? ( !<kde-base/kde-wallpapers-$PV[kdeprefix=] )"
