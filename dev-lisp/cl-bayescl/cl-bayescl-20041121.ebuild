# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-bayescl/cl-bayescl-20041121.ebuild,v 1.4 2005/05/24 18:48:32 mkennedy Exp $

inherit common-lisp eutils

DESCRIPTION="Bayescl is a general purpose Bayesian pattern filtering library for Common Lisp."
HOMEPAGE="http://common-lisp.net/project/bayescl/"
SRC_URI="mirror://gentoo/bayescl-${PV}.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
S=${WORKDIR}/bayescl

DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=bayescl

src_install() {
	common-lisp-install *.asd *.lisp
	common-lisp-system-symlink
	dodoc BUGS COPYING README TODO
}
