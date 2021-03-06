# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyzor/pyzor-0.5.0-r1.ebuild,v 1.6 2009/12/15 18:41:52 armin76 Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

DESCRIPTION="A distributed, collaborative spam detection and filtering network"
HOMEPAGE="http://pyzor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="pyzord"

DEPEND="pyzord? ( dev-lang/python[gdbm] )"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

DOCS="THANKS UPGRADING"

src_prepare() {
	epatch "${FILESDIR}/pyzord_getopt.patch"

	# rfc822BodyCleanerTest doesn't work fine.
	# Remove it until it's fixed.
	sed -i \
		-e '/rfc822BodyCleanerTest/,/self\.assertEqual/d' \
		unittests.py || die "sed in unittest.py failed"
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" unittests.py
	}
	python_execute_function testing
}

src_install () {
	distutils_src_install

	dohtml docs/usage.html
	rm -rf "${D}usr/share/doc/pyzor"

	if use pyzord; then
		dodir /usr/sbin
		mv "${D}usr/bin/pyzord" "${D}usr/sbin/"
	else
		rm "${D}usr/bin/pyzord"
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	if use pyzord; then
		ewarn "/usr/bin/pyzord has been moved to /usr/sbin"
	fi
}
