# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-RawIP/Net-RawIP-0.25.ebuild,v 1.6 2010/02/10 04:08:11 josejx Exp $

MODULE_AUTHOR=SAPER
inherit perl-module

DESCRIPTION="Perl Net::RawIP - Raw IP packets manipulation Module"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND="net-libs/libpcap
	dev-lang/perl"
DEPEND="${RDEPEND}"
