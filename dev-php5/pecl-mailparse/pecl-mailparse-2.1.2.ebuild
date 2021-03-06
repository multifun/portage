# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-mailparse/pecl-mailparse-2.1.2.ebuild,v 1.2 2007/12/06 01:12:02 jokey Exp $

PHP_EXT_NAME="mailparse"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

DOCS="README"
inherit php-ext-pecl-r1

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="A PHP extension for parsing and working with RFC822 and RFC2045 (MIME) compliant messages."
LICENSE="PHP-2.02"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

need_php_by_category

pkg_setup() {
	require_php_with_use unicode
}
