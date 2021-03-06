# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/refe/refe-0.8.0.ebuild,v 1.10 2009/04/14 17:37:07 graaff Exp $

inherit ruby

IUSE=""

DESCRIPTION="ReFe is an interactive reference for Japanese Ruby manual"
HOMEPAGE="http://www.loveruby.net/ja/prog/refe.html"
SRC_URI="http://www.loveruby.net/archive/refe/${P}-withdoc.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ia64 ~ppc ppc64 x86"
USE_RUBY="ruby18"

src_compile() {

	erubyconf || die
	# do not run make for this package
}

src_install() {

	erubyinstall || die

	erubydoc
}
