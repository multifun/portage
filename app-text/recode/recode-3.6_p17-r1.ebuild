# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/recode/recode-3.6_p17-r1.ebuild,v 1.1 2010/06/15 12:00:12 jlec Exp $

EAPI="3"

inherit autotools eutils flag-o-matic libtool toolchain-funcs

MY_P=${P%_*}
MY_PV=${PV%_*}
DEB_PATCH=${PV#*p}

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="http://recode.progiciels-bpi.ca/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${MY_PV}-${DEB_PATCH}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

DEPEND="
	sys-devel/flex
	nls? ( sys-devel/gettext )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${MY_P}-gettextfix.diff" #239372
	epatch "${FILESDIR}"/${MY_P}-as-if.patch #283029
	epatch "${WORKDIR}"/${PN}_${MY_PV}-${DEB_PATCH}.diff
	sed -i '1i#include <stdlib.h>' src/argmatch.c || die

	# Needed under FreeBSD, too
	# Needed under Interix too
	# now replaced by the -new.patch ...
	# epatch "${FILESDIR}"/${MY_P}-ppc-macos.diff
	epatch "${FILESDIR}"/${MY_P}-ppc-macos-new.diff
	[[ ${CHOST} == *-interix[35]* ]] && epatch "${FILESDIR}"/${PN}-3.6-interix-getopt.patch
	cp lib/error.c lib/xstrdup.c lib/getopt.c lib/getopt1.c src/ || die "file copy failed"

	# Remove old libtool macros
	rm "${S}"/acinclude.m4

	eautoreconf
	elibtoolize
}

src_configure() {
	tc-export CC LD
	# on solaris -lintl is needed to compile
	[[ ${CHOST} == *-solaris* ]] && append-libs "-lintl"
	# --without-included-gettext means we always use system headers
	# and library
	econf --without-included-gettext $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BACKLOG ChangeLog NEWS README THANKS TODO
	rm -f "${ED}"/usr/lib/charset.alias
}
