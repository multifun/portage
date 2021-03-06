# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-tbnl/cl-tbnl-0.11.2.ebuild,v 1.3 2007/05/19 21:02:41 welp Exp $

inherit common-lisp

DESCRIPTION="TBNL is a toolkit for building dynamic websites with Common Lisp based on mod_lisp."
HOMEPAGE="http://www.weitz.de/tbnl/"
SRC_URI="mirror://gentoo/tbnl_${PV}.orig.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="standalone"

DEPEND="dev-lisp/cl-kmrcl
	dev-lisp/cl-md5
	dev-lisp/cl-base64
	dev-lisp/cl-url-rewrite
	dev-lisp/cl-ppcre
	dev-lisp/cl-rfc2388"

RDEPEND="${DEPEND}
	!standalone? ( >=www-apache/mod_lisp2-1.2 )"

S=${WORKDIR}/tbnl-${PV}

CLPACKAGE=tbnl

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	insinto $CLSOURCEROOT/$CLPACKAGE/
	doins -r test contrib
	dodoc CHANGELOG README
	dohtml doc/index.html
}
