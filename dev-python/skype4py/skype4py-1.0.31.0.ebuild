# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/skype4py/skype4py-1.0.31.0.ebuild,v 1.3 2009/08/20 03:23:43 darkside Exp $

inherit distutils eutils

DESCRIPTION="Python wrapper for the Skype API."
HOMEPAGE="https://developer.skype.com/wiki/Skype4Py"
SRC_URI="mirror://sourceforge/${PN}/Skype4Py-${PV}.tar.gz
		 doc? ( mirror://sourceforge/${PN}/Skype4Py-${PV}-htmldoc.zip )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="${DEPEND}
	net-im/skype"

S="${WORKDIR}/Skype4Py-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use doc && mv "${WORKDIR}/Skype4Py-${PV}-htmldoc" "${S}/html_doc"
	epatch "${FILESDIR}/${P}-automagic-cython.patch"
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml html_doc/* || die "dohtml failed"
	fi
}
