# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/rtmpdump/rtmpdump-2.2e-r3.ebuild,v 1.1 2010/06/17 21:56:25 hwoarang Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Open source command-line RTMP client intended to stream audio or video flash content"
HOMEPAGE="http://rtmpdump.mplayerhq.hu/"
SRC_URI="http://rtmpdump.mplayerhq.hu/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnutls polarssl ssl"

DEPEND="ssl? (
		gnutls? ( net-libs/gnutls )
		polarssl? ( !gnutls? ( net-libs/polarssl ) )
		!gnutls? ( !polarssl? ( dev-libs/openssl ) )
	)
	sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! use ssl && ( use gnutls ||	use polarssl ) ; then
		ewarn "USE='gnutls polarssl' are ignored without USE='ssl'."
		ewarn "Please review the local USE flags for this package."
	fi
}

src_prepare() {
	# fix Makefile ( bug #298535 , bug #318353 and bug #324513 )
	sed -i 's/\$(MAKEFLAGS)//g' Makefile \
		|| die "failed to fix Makefile"
	sed -i -e 's:OPT=:&-fPIC :' \
		-e 's:OPT:OPTS:' \
		-e 's:CFLAGS=.*:& $(OPT):' librtmp/Makefile \
		|| die "failed to fix Makefile"
}

src_compile() {
	if use ssl ; then
		if use gnutls ;	then
			crypto="GNUTLS"
		elif use polarssl ; then
			crypto="POLARSSL"
		else
			crypto="OPENSSL"
		fi
	fi

	emake CC=$(tc-getCC) LD=$(tc-getLD) \
		OPT="${CFLAGS}" XLDFLAGS="${LDFLAGS}" CRYPTO="${crypto}" SYS=posix || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" prefix="${DESTTREE}" mandir="${DESTTREE}/share/man" \
	CRYPTO="${crypto}" install 	|| die "emake install failed"
	dodoc README ChangeLog rtmpdump.1.html rtmpgw.8.html || die "dodoc failed"
}
