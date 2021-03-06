# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

MODULE_AUTHOR=BRICAS
inherit perl-module

DESCRIPTION="(DEPRECATED) DBIC Model Class"
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND="dev-perl/Catalyst-Runtime
	dev-perl/DBIx-Class
	dev-perl/DBIx-Class-Loader"

pkg_setup() {
	ewarn "This module is DEPRECATED, please switch to Catalyst::Model::DBIC-Schema."
}
