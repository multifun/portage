# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/indent/indent-2.2.10-r1.ebuild,v 1.11 2010/03/23 16:46:22 jer Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Indent program source files"
HOMEPAGE="http://www.gnu.org/software/indent/indent.html"
SRC_URI="mirror://gnu/indent/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="nls"

DEPEND="
	nls? ( sys-devel/gettext )
	app-text/texi2html
"
RDEPEND="nls? ( virtual/libintl )"

src_prepare() {
	# Fix parallel make issue in man/ (bug #76610)
	epatch "${FILESDIR}"/${PV}-man.patch
	# Make texinfo2man behave when insufficient arguments are fed
	epatch "${FILESDIR}"/${PV}-segfault.patch
	eautoreconf
}

src_configure() {
	# LINGUAS is used in aclocal.m4 (bug #94837)
	unset LINGUAS
	econf $(use_enable nls) || die "configure failed"
}

src_test() {
	emake -C regression/ || die "regression tests failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		install || die "make install failed"
	dodoc AUTHORS NEWS README* ChangeLog*
}
