# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-wallpapers/kdebase-wallpapers-4.3.5.ebuild,v 1.4 2010/06/21 15:53:17 scarabeus Exp $

EAPI="2"

KMNAME="kdebase-workspace"
KMMODULE="wallpapers"
inherit kde4-meta

DESCRIPTION="KDE wallpapers"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

add_blocker kde-wallpapers
