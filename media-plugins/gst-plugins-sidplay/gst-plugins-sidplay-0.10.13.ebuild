# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-sidplay/gst-plugins-sidplay-0.10.13.ebuild,v 1.5 2010/04/18 15:52:55 nixnut Exp $

inherit gst-plugins-ugly

KEYWORDS="alpha amd64 ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND="=media-libs/libsidplay-1.3*
	 >=media-libs/gstreamer-0.10.25
	 >=media-libs/gst-plugins-base-0.10.25"
DEPEND="${RDEPEND}"
