# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope-schema/zope-schema-3.6.3.ebuild,v 1.1 2010/05/18 13:37:05 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="zope.interface extension for defining data schemas"
HOMEPAGE="http://pypi.python.org/pypi/zope.schema"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="net-zope/zope-event
	net-zope/zope-interface
	net-zope/zope-i18nmessageid"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools
	test? ( net-zope/zope-testing )"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="${PN/-//}"
DOCS="CHANGES.txt README.txt"
