# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Locale-Maketext-Simple/Locale-Maketext-Simple-0.21.ebuild,v 1.2 2009/12/16 21:52:39 abcd Exp $

EAPI=2

MODULE_AUTHOR=JESSE
inherit perl-module

DESCRIPTION="Locale::Maketext::Simple - Simple interface to Locale::Maketext::Lexicon"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-perl/locale-maketext-lexicon )"

SRC_TEST="do"
