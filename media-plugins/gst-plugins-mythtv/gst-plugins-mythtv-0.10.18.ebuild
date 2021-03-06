# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mythtv/gst-plugins-mythtv-0.10.18.ebuild,v 1.1 2010/04/05 05:47:09 leio Exp $

inherit gst-plugins-bad

DESCRIPION="plugin to allow retrieving from a mythbackend"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=media-libs/gmyth-0.4
	<=media-libs/gmyth-0.7.99
	>=media-libs/gst-plugins-base-0.10.27"
DEPEND="${RDEPEND}"
