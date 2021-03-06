# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/freehdl/freehdl-0.0.3.ebuild,v 1.3 2007/07/15 03:25:39 mr_bones_ Exp $

DESCRIPTION="A free VHDL simulator."
SRC_URI="http://cran.mit.edu/~enaroska/${P}.tar.gz"
HOMEPAGE="http://freehdl.seul.org/"
LICENSE="GPL-2"
DEPEND=">=sys-devel/gcc-3.4.3.20050110-r2"
RDEPEND=">=dev-scheme/guile-1.2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

src_install () {
	make DESTDIR=${D} install || die "installation failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README*
}
