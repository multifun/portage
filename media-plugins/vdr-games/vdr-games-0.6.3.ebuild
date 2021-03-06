# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-games/vdr-games-0.6.3.ebuild,v 1.2 2006/11/21 21:29:57 zzam Exp $

inherit vdr-plugin

DESCRIPTION="Video Disk Recorder games plugin"
HOMEPAGE="http://1541.org/"
SRC_URI="http://1541.org/public/${P}.tar.gz
	mirror://vdrfiles/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"

PATCHES="${FILESDIR}/${P}-gentoo.diff"
