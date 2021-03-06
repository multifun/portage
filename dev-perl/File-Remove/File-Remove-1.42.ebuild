# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Remove/File-Remove-1.42.ebuild,v 1.6 2010/06/20 18:32:38 armin76 Exp $

MODULE_AUTHOR=ADAMK
inherit perl-module

DESCRIPTION="Remove files and directories"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND=">=virtual/perl-File-Spec-0.84
	dev-lang/perl"

SRC_TEST="do"
