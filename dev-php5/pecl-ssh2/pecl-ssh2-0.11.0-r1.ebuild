# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-ssh2/pecl-ssh2-0.11.0-r1.ebuild,v 1.1 2009/12/29 21:16:55 hoffie Exp $

PHP_EXT_NAME="ssh2"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README ChangeLog"

inherit php-ext-pecl-r1

DESCRIPTION="Provides bindings to the functions of libssh2 which implements the SSH2 protocol."
LICENSE="PHP-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
DEPEND=">=net-libs/libssh2-0.18"
RDEPEND="${DEPEND}"

need_php_by_category

src_unpack() {
	php-ext-source-r1_src_unpack
	epatch "${FILESDIR}"/${P}-php-5.3-compat.patch
}
