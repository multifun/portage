# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pudb/pudb-0.92.15.ebuild,v 1.1 2010/01/17 17:42:04 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A full-screen, console-based Python debugger"
HOMEPAGE="http://pypi.python.org/pypi/pudb"
SRC_URI="http://pypi.python.org/packages/source/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-interix ~x86-linux"
IUSE=""

RDEPEND="dev-python/urwid
	dev-python/pygments"
DEPEND="${RDEPEND}
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="3.*"
