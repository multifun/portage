# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Algorithm-Dependency/Algorithm-Dependency-1.110.ebuild,v 1.5 2010/05/08 17:47:22 armin76 Exp $

EAPI=2

MODULE_AUTHOR=ADAMK
inherit perl-module

DESCRIPTION="Toolkit for implementing dependency systems"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND=">=dev-perl/Params-Util-0.31
	>=virtual/perl-File-Spec-0.82"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-ClassAPI )"

SRC_TEST="do"
