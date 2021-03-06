# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-daemon/python-daemon-1.6.ebuild,v 1.1 2010/05/10 16:54:51 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Library to implement a well-behaved Unix daemon process."
HOMEPAGE="http://pypi.python.org/pypi/python-daemon"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/lockfile-0.9"
DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( dev-python/minimock )"
# dev-python/lockfile requires >=2.5.
RESTRICT_PYTHON_ABIS="2.4 3.*"

PYTHON_MODNAME="daemon"
DOCS="ChangeLog"
