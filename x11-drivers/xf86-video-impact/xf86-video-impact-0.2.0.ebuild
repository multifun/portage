# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-impact/xf86-video-impact-0.2.0.ebuild,v 1.5 2009/09/30 21:29:21 ssuominen Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"
XDPVER=2

inherit x-modular

DESCRIPTION="Impact video driver"
KEYWORDS="-* mips"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xproto"

PATCHES=( "${FILESDIR}/${P}-DCACHE.patch" )
