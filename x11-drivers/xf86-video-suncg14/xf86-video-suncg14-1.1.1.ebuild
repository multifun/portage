# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-suncg14/xf86-video-suncg14-1.1.1.ebuild,v 1.3 2010/04/16 21:33:31 pacho Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="CG14 video driver"
KEYWORDS="-* ~sparc"
IUSE=""
RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xproto"
