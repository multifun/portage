# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kopete-thinklight/kopete-thinklight-0.50.ebuild,v 1.1 2009/11/09 13:27:25 ssuominen Exp $

EAPI=2
inherit kde4-base

DESCRIPTION="A thinkpad's light flash on every incoming message"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=100537"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/100537-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/kopete-${KDE_MINIMAL}"

DOCS="CREDITS"
