# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/geda-examples/geda-examples-1.4.3.ebuild,v 1.3 2010/03/04 12:45:16 phajdan.jr Exp $

inherit versionator

DESCRIPTION="GPL Electronic Design Automation: examples"
HOMEPAGE="http://www.gpleda.org/"
SRC_URI="http://geda.seul.org/release/v$(get_version_component_range 1-2)/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="!<sci-electronics/geda-1.4.3-r1"
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README
}
