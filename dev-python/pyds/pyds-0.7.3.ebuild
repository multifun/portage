# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyds/pyds-0.7.3.ebuild,v 1.1 2008/02/28 21:53:07 dev-zero Exp $

NEED_PYTHON="2.3"

inherit distutils eutils

MY_P="PyDS-${PV}"

DESCRIPTION="Python Desktop Server"
HOMEPAGE="http://pyds.muensterland.org/"
SRC_URI="http://simon.bofh.ms/~gb/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
SLOT="0"
LICENSE="MIT"
IUSE=""

RDEPEND="media-libs/jpeg
	sys-libs/zlib
	>=dev-python/medusa-0.5.4
	>=dev-db/metakit-2.4.9.2
	>=dev-python/cheetah-0.9.15
	>=dev-python/pyxml-0.8.2
	>=dev-python/pyrex-0.5
	>=dev-python/docutils-0.3
	>=dev-python/imaging-1.1.3
	>=dev-python/soappy-0.11.1
	app-text/silvercity"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="OVERVIEW"

src_unpack() {
	distutils_src_unpack

	cd "${S}/PyDS"
	epatch "${FILESDIR}/${PN}-0.6.5-py2.3.patch"
}
