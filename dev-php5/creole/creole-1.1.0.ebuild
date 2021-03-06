# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/creole/creole-1.1.0.ebuild,v 1.5 2009/02/24 01:50:15 josejx Exp $

inherit php-pear-lib-r1

KEYWORDS="~amd64 ~ppc ~x86"

DESCRIPTION="Database abstraction layer for PHP 5."
HOMEPAGE="http://creole.phpdb.org/trac/wiki/"
SRC_URI="http://pear.phpdb.org/get/${P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=">=dev-php5/jargon-1.1.0"

need_php_by_category
