# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/xlwt/xlwt-0.7.2.ebuild,v 1.4 2010/02/06 14:22:42 arfrever Exp $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Python library to create spreadsheet files compatible with Excel"
HOMEPAGE="http://pypi.python.org/pypi/xlwt/"
SRC_URI="http://cheeseshop.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="examples"

DEPEND=""
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	distutils_src_prepare

	# Don't install documentation and examples in site-packages directories.
	sed -e "/package_data/,+6d" -i setup.py || die "sed failed"
}

src_test() {
	cd tests
	testing() {
		PYTHONPATH="../build-${PYTHON_ABI}/lib" "$(PYTHON)" RKbug.py 1
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins -r HISTORY.html xlwt/doc/xlwt.html tests
	if use examples; then
		doins -r xlwt/examples || die "doins failed"
	fi
}
