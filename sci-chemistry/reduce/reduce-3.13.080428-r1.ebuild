# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/reduce/reduce-3.13.080428-r1.ebuild,v 1.2 2010/04/22 20:32:15 jlec Exp $

EAPI="3"

inherit eutils toolchain-funcs

MY_P="${PN}.${PV}.src"

DESCRIPTION="Adds hydrogens to a Protein Data Bank (PDB) molecule structure file"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/reduce.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/reduce31/${MY_P}.tgz"

LICENSE="richardson"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-LDFLAGS.patch
}

src_compile() {
	DICT_DIR="${EPREFIX}/usr/share/reduce"
	DICT_FILE="reduce_het_dict.txt"

	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		OPT="${CXXFLAGS}" \
		DICT_HOME="${EPREFIX}/${DICT_DIR}/${DICT_FILE}" \
		|| die "make failed"
}

src_install() {
	dobin "${S}"/reduce_src/reduce || die
	insinto ${DICT_DIR}
	doins "${S}"/${DICT_FILE} "${S}"/reduce_wwPDB_het_dict.txt || die
	dodoc README.usingReduce.txt || die
}

pkg_info() {
	elog "To use the PDBv3 dictionary instead of PDBv2, set the environment"
	elog "variable REDUCE_HET_DICT to ${EPREFIX}/usr/share/reduce/reduce_wwPDB_het_dict.txt"
}

pkg_postinst() {
	pkg_info
}
