# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycrypto/pycrypto-2.1.0.ebuild,v 1.10 2010/06/20 17:38:53 armin76 Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils flag-o-matic

DESCRIPTION="Python Cryptography Toolkit"
HOMEPAGE="http://www.dlitz.net/software/pycrypto/ http://pypi.python.org/pypi/pycrypto"
SRC_URI="http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/${P}.tar.gz"

LICENSE="public-domain PSF-2.2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ~ppc64 s390 sh sparc x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +gmp"

RDEPEND="gmp? ( dev-libs/gmp )"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils dev-python/epydoc )"

DOCS="ACKS ChangeLog README TODO"
PYTHON_MODNAME="Crypto"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-2.1.0-gmp.patch"
}

src_configure() {
	use gmp \
		&& export USE_GMP="1" \
		|| export USE_GMP="0"
}

src_compile() {
	# Some tests fail with some limit of inlining of functions.
	# Avoid warnings about breaking strict-aliasing rules.
	append-flags -fno-inline-functions -fno-strict-aliasing

	distutils_src_compile

	if use doc; then
		rst2html.py Doc/pycrypt.rst > Doc/index.html

		PYTHONPATH="$(ls -d build-$(PYTHON --ABI -f)/lib.*)" epydoc --config=Doc/epydoc-config --exclude-introspect="^Crypto\.(Random\.OSRNG\.nt|Util\.winrandom)$" || die "Generation of documentation failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml Doc/index.html || die "dohtml failed"
		dohtml Doc/apidoc/* || die "dohtml failed"
	fi
}
