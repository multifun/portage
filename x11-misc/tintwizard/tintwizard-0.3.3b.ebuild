# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/tintwizard/tintwizard-0.3.3b.ebuild,v 1.2 2010/05/08 13:27:15 idl0r Exp $

EAPI="3"

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="GUI wizard which generates config files for tint2 panels"
HOMEPAGE="http://code.google.com/p/tintwizard/"
SRC_URI="http://tintwizard.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="x11-misc/tint2
	dev-python/pygtk:2"

src_prepare() {
	python_convert_shebangs 2 tintwizard.py
}

src_install() {
	dodoc ChangeLog
	newbin tintwizard.py tintwizard || die
}
