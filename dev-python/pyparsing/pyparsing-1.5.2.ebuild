# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyparsing/pyparsing-1.5.2.ebuild,v 1.12 2009/12/30 00:59:22 arfrever Exp $

EAPI="2"

NEED_PYTHON="2.6"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="pyparsing is an easy-to-use Python module for text parsing"
HOMEPAGE="http://pyparsing.wikispaces.com/ http://pypi.python.org/pypi/pyparsing"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples"

DEPEND=""
RDEPEND=""
RESTRICT_PYTHON_ABIS="2.4 2.5"

PYTHON_MODNAME="pyparsing.py"

src_prepare() {
	distutils_src_prepare

	mv -f pyparsing_py3.py pyparsing.py || die "mv failed"
	sed -e 's/, "pyparsing_py3"//' -i setup.py || die "sed failed"
	sed -e "s/pyparsing_py3 as pyparsing/pyparsing/" -e "s/pyparsing_py3/pyparsing/" -i pyparsing.py
}

src_install() {
	distutils_src_install

	dohtml HowToUsePyparsing.html
	dodoc CHANGES

	if use doc; then
		dohtml -r htmldoc/*
		insinto /usr/share/doc/${PF}
		doins docs/*.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
