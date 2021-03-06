# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/stomper/stomper-0.2.2-r1.ebuild,v 1.4 2010/02/07 21:01:51 pva Exp $

EAPI="2"
#SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils

DESCRIPTION="This is a transport neutral client implementation of the STOMP protocol."
HOMEPAGE="http://pypi.python.org/pypi/stomper"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools"

RESTRICT_PYTHON_ABIS="3*"

src_prepare() {
	epatch "${FILESDIR}/${P}-dont_require_separate_uuid_package.patch"
}
