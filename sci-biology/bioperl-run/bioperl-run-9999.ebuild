# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bioperl-run/bioperl-run-9999.ebuild,v 1.2 2009/05/13 15:49:54 weaver Exp $

EAPI="2"

inherit perl-module subversion

DESCRIPTION="Perl tools for bioinformatics - Wrapper modules around key bioinformatics applications"
HOMEPAGE="http://www.bioperl.org/"
SRC_URI=""
ESVN_REPO_URI="svn://code.open-bio.org/bioperl/${PN}/trunk"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="-minimal test"
SRC_TEST="do"

CDEPEND=">=sci-biology/bioperl-${PV}
	!minimal? (
		dev-perl/Algorithm-Diff
		dev-perl/XML-Twig
		dev-perl/IO-String
		dev-perl/IPC-Run
	)"
DEPEND="virtual/perl-Module-Build
	${CDEPEND}"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/BioPerl-run-${PV}"

src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
	# TODO: File collision in Bio/ConfigData.pm (a Module::Build internal file)
	# with sci-biology/bioperl. Workaround: the "nuke it from orbit" solution :D
	find "${D}" -name '*ConfigData*' -print -delete
}
