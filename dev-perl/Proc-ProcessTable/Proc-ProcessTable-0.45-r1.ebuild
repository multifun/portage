# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Proc-ProcessTable/Proc-ProcessTable-0.45-r1.ebuild,v 1.1 2010/05/20 21:56:37 hwoarang Exp $

EAPI="2"

MODULE_AUTHOR=DURIST
inherit perl-module

DESCRIPTION="Unix process table information"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/perl-Storable
	dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}/amd64_canonicalize_file_name_definition.patch"
	perl-module_src_prepare
}
