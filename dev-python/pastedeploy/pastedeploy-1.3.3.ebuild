# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pastedeploy/pastedeploy-1.3.3.ebuild,v 1.6 2010/02/06 15:38:04 arfrever Exp $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils multilib

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="http://pythonpaste.org/deploy/ http://pypi.python.org/pypi/PasteDeploy"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc test"

RDEPEND=""
DEPEND="dev-python/setuptools
	doc? ( dev-python/buildutils dev-python/pygments dev-python/pudge )
	test? ( dev-python/nose dev-python/py )"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="paste/deploy"

src_compile() {
	distutils_src_compile
	if use doc; then
		einfo "Generating docs as requested..."
		PYTHONPATH=. "$(PYTHON -f)" setup.py pudge || die "Generation of documentation failed"
	fi
}

src_test() {
	# Delete broken test.
	rm -f tests/test_config_middleware.py

	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" nosetests-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	use doc && dohtml -r docs/html/*
}
