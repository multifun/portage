# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-salza/cl-salza-0.7.2.ebuild,v 1.1 2005/06/20 16:25:21 mkennedy Exp $

inherit common-lisp

DESCRIPTION='Salza is a Common Lisp Library that provides an FFI-less interface to the ZLIB and DEFLATE compressed data formats.'
HOMEPAGE="http://www.cliki.net/Salza"
SRC_URI="http://www.xach.com/lisp/salza/salza-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=salza

S=${WORKDIR}/salza-${PV}

src_install() {
	common-lisp-install *.asd *.lisp
	common-lisp-system-symlink
	dodoc README ChangeLog LICENSE
	docinto examples
	dodoc examples/*
}
