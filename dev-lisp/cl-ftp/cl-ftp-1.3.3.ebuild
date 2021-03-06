# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-ftp/cl-ftp-1.3.3.ebuild,v 1.5 2007/07/15 02:50:08 mr_bones_ Exp $

inherit common-lisp

DESCRIPTION="CL-FTP is a Networking Library that provides FTP client (for now) functionality to Common Lisp programs."
HOMEPAGE="http://www.mapcar.org/~mrd/cl-ftp/
	http://packages.debian.org/unstable/devel/cl-ftp
	http://www.cliki.net/CL-FTP"
SRC_URI="mirror://debian/pool/main/c/cl-ftp/${PN}_${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp
	dev-lisp/cl-acl-compat
	dev-lisp/cl-split-sequence"

CLPACKAGE=ftp

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc LICENSE
	do-debian-credits
}
