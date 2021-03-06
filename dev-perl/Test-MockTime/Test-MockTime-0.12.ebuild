# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-MockTime/Test-MockTime-0.12.ebuild,v 1.2 2009/06/10 12:55:06 tove Exp $

EAPI=2

MODULE_AUTHOR=DDICK
inherit perl-module

DESCRIPTION="Replaces actual time with simulated time"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Time-Piece
	virtual/perl-Time-Local"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST=do
