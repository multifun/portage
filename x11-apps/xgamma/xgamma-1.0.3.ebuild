# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xgamma/xgamma-1.0.3.ebuild,v 1.8 2010/01/17 22:33:10 jer Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Alter a monitor's gamma correction through the X server"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND="x11-libs/libXxf86vm
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto"
