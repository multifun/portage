# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/nose/nose-0.11.0.ebuild,v 1.6 2009/08/02 14:52:12 maekke Exp $

EAPI="2"

inherit distutils eutils

DESCRIPTION="A unittest extension offering automatic test suite discovery and easy test authoring"
HOMEPAGE="http://somethingaboutorange.com/mrl/projects/nose/"
SRC_URI="http://somethingaboutorange.com/mrl/projects/nose/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="doc examples test"

RDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? ( dev-python/twisted )"

src_prepare() {
	distutils_src_prepare

	# Disable tests and doc features that access the network
	epatch \
		"${FILESDIR}/${PN}-0.10.0-tests-nonetwork.patch" \
		"${FILESDIR}/${P}-disable_intersphinx.patch"
}

src_compile() {
	distutils_src_compile

	if use doc ; then
		cd doc
		mkdir -p .build/html .build/doctrees
		sphinx-build . html || die "building docs failed"
	fi
}

src_install() {
	DOCS="AUTHORS"
	distutils_src_install --install-data /usr/share

	use doc && dohtml -r -A txt doc/html/*

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

src_test() {
	# Create the missing empty directory, that's required for tests to pass
	if [[ ! -e "${S}"/functional_tests/support/empty ]]; then
		mkdir "${S}"/functional_tests/support/empty
	fi
	PYTHONPATH=. "${python}" setup.py test || die "test failed"
}
