# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Format/HTML-Format-2.04.ebuild,v 1.16 2008/08/19 21:18:49 dertobi123 Exp $

# this is an RT dependency
inherit perl-module

DESCRIPTION="HTML Formatter"
SRC_URI="mirror://cpan/authors/id/S/SB/SBURKE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~sburke/"

SRC_TEST="do"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ia64 ppc sparc x86"

DEPEND="dev-perl/Font-AFM
	dev-perl/HTML-Tree
	dev-lang/perl"
IUSE=""
