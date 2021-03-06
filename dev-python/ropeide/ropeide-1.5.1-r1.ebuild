# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ropeide/ropeide-1.5.1-r1.ebuild,v 1.2 2010/06/09 21:36:23 patrick Exp $

NEED_PYTHON="2.5"
EAPI=2
inherit distutils

DESCRIPTION="Python refactoring IDE"
HOMEPAGE="http://rope.sourceforge.net/"
SRC_URI="mirror://sourceforge/rope/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-python/rope-0.8.4
		>=dev-lang/python-2.5[tk]"

src_install() {
	distutils_src_install
	use doc && dodoc docs/*.txt
}
