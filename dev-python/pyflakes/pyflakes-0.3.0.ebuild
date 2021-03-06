# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyflakes/pyflakes-0.3.0.ebuild,v 1.5 2010/01/03 21:08:04 arfrever Exp $

EAPI="2"

inherit distutils

DESCRIPTION="Passive checker for python programs."
HOMEPAGE="http://divmod.org/trac/wiki/DivmodPyflakes"
SRC_URI="http://pypi.python.org/packages/source/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="test"

DEPEND="test? ( dev-python/nose )"
RDEPEND=""

src_test() {
	PYTHONPATH="build/lib" nosetests || die "Tests failed"
}
