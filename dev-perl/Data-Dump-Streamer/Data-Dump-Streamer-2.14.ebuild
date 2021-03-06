# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Dump-Streamer/Data-Dump-Streamer-2.14.ebuild,v 1.1 2010/06/09 05:44:02 tove Exp $

EAPI=3

MODULE_AUTHOR=JJORE
inherit perl-module

DESCRIPTION="Accurately serialize a data structure as Perl code"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/B-Utils-0.07"
RDEPEND="${DEPEND}"

SRC_TEST=do
