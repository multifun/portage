# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mmv/mmv-1.01b_p15.ebuild,v 1.2 2010/06/15 11:25:13 jlec Exp $

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs

DEB_PATCH_VER=${PV#*_p}
MY_VER=${PV%_p*}

DESCRIPTION="Move/copy/append/link multiple files according to a set of wildcard patterns."
HOMEPAGE="http://packages.debian.org/unstable/utils/mmv"
SRC_URI="
	mirror://debian/pool/main/m/mmv/${PN}_${MY_VER}.orig.tar.gz
	mirror://debian/pool/main/m/mmv/${PN}_${MY_VER}-${DEB_PATCH_VER}.diff.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

S="${WORKDIR}"/${PN}-${MY_VER}.orig

src_prepare() {
	epatch "${DISTDIR}"/${PN}_${MY_VER}-${DEB_PATCH_VER}.diff.gz
}

src_compile() {
	# i wonder how this works on other platforms if CFLAGS from makefile are
	# overridden, see bug #218082
	[[ ${CHOST} == *-interix* ]] && append-flags -DIS_SYSV -DHAS_RENAME -DHAS_DIRENT
	[[ ${CHOST} == *-interix* ]] || append-lfs-flags

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin mmv || die
	dosym mmv /usr/bin/mcp || die
	dosym mmv /usr/bin/mln || die
	dosym mmv /usr/bin/mad || die

	doman mmv.1 || die
	dosym mmv.1.gz /usr/share/man/man1/mcp.1.gz || die
	dosym mmv.1.gz /usr/share/man/man1/mln.1.gz || die
	dosym mmv.1.gz /usr/share/man/man1/mad.1.gz || die

	dodoc ANNOUNCE debian/{changelog,control} || die
}
