# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-IniFiles/Config-IniFiles-2.56.ebuild,v 1.1 2009/12/31 16:30:37 tove Exp $

EAPI=2

MODULE_AUTHOR=SHLOMIF
inherit perl-module

DESCRIPTION="A module for reading .ini-style configuration files"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="dev-perl/IO-stringy"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
