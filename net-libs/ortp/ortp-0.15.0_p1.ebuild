# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ortp/ortp-0.15.0_p1.ebuild,v 1.7 2009/12/25 18:13:01 armin76 Exp $

EAPI="2"

inherit eutils

MY_P=${P/_p1/}

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="http://www.linphone.org/index.php/eng/code_review/ortp/"
SRC_URI="http://download.savannah.nongnu.org/releases/linphone/${PN}/sources/${MY_P}.tar.gz
	mirror://gentoo/${P}-linphone-3.1.0.patch.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="debug doc examples ipv6 minimal srtp ssl"

RDEPEND="srtp? ( net-libs/libsrtp )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# diff patch from linphone-3.1.0 bundled ortp
	epatch "${WORKDIR}"/${P}-linphone-3.1.0.patch

	# to be sure doc is not builded nor installed w/ -doc and doxygen installed
	if ! use doc; then
		sed -i -e 's/test $DOXYGEN != //' configure \
			|| die "patching configure failed"
	fi

	# to authorize -srtp even with libsrtp installed
	if ! use srtp; then
		sed -i -e 's/$have_srtp_headers$have_srtp_lib//' configure \
			|| die "patching configure failed"
	fi

	# to authorize -ssl even with openssl installed
	if ! use ssl; then
		sed -i -e 's/SSL_LIBS=".*"/SSL_LIBS=""/' \
			-e 's/openssl\/.*.h/poll.h/' configure \
			|| die "patching configure failed"
	fi

	# do not build examples programs, see bug 226247
	sed -i -e 's/SUBDIRS = . tests/SUBDIRS = ./' src/Makefile.in \
		|| die "patching src/Makefile.in failed"

	# ${P} is added after ${docdir}
	if use doc; then
		sed -i -e 's/$(docdir)\/$(PACKAGE)-$(VERSION)/$(docdir)/' Makefile.in \
			|| die "patching Makefile.in failed"
	fi
}

src_configure() {
	# force docdir to standard Gentoo doc directory
	# memcheck is for HP-UX only
	# mode64bit adds +DA2.0W +DS2.0 CFLAGS wich are needed for HP-UX
	# strict adds -Werror, don't want it
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-memcheck \
		--disable-mode64bit \
		--disable-strict \
		--disable-dependency-tracking \
		--enable-fast-install \
		--enable-libtool-lock \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable minimal perf)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/tests/*.c || die "doins failed"
	fi
}
