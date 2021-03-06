# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xeyes/xeyes-1.0.1.ebuild,v 1.5 2009/05/05 07:51:26 fauli Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xeyes application"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""
RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXmu"
DEPEND="${RDEPEND}"
