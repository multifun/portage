# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

MODULE_AUTHOR=HOLOWAY
inherit perl-module

DESCRIPTION="Log::Log4perl logging for Catalyst"
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND="dev-perl/Catalyst-Runtime
	dev-perl/Log-Log4perl
	dev-perl/Params-Validate"
