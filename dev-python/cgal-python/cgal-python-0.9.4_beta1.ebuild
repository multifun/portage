# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cgal-python/cgal-python-0.9.4_beta1.ebuild,v 1.4 2010/06/16 01:43:15 arfrever Exp $

EAPI=2
inherit eutils flag-o-matic toolchain-funcs python

MY_P=${P/_/-}

DESCRIPTION="Python bindings for the CGAL library"
HOMEPAGE="http://cgal-python.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/19498/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-libs/mpfr
	>=sci-mathematics/cgal-3.5.1"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-linking.patch

	if has_version sci-mathematics/cgal[gmp]; then
		sed -i \
			-e 's:$(CGAL_LDFLAGS):-lgmp $(CGAL_LDFLAGS):' \
			bindings/makefile.inc || die
	fi

	sed -i \
		-e "s:-I../.. -O2:-I$(python_get_includedir) -I../..:g" \
		bindings/makefile.inc || die
	for i in $(find bindings -name Makefile); do
		sed -i -e "s:@g++:@$(tc-getCXX):g" ${i}  || die
	done
}

src_compile() {
	append-cxxflags -frounding-math
	emake || die
}

src_test() {
	emake -j1 tests || die
}

src_install(){
	python_need_rebuild
	emake package || die
	insinto $(python_get_sitedir)
	doins -r cgal_package/CGAL || die
	dodoc README.txt CHANGES
	if use examples; then
		cd tests
		emake clean
		insinto /usr/share/doc/${PF}/examples
		cp -r * || die
	fi
}
