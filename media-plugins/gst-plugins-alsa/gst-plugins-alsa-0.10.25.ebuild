# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-alsa/gst-plugins-alsa-0.10.25.ebuild,v 1.6 2010/04/18 15:38:46 nixnut Exp $

inherit gst-plugins-base

KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ~ppc64 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/alsa-lib-0.9.1"
DEPEND="${RDEPEND}"
