# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libstroke/libstroke-0.5.1.ebuild,v 1.22 2007/09/19 09:24:33 calchan Exp $

WANT_AUTOMAKE=1.4
inherit eutils autotools

DESCRIPTION="A Stroke and Gesture recognition Library"
HOMEPAGE="http://www.etla.net/libstroke/"
SRC_URI="http://www.etla.net/libstroke/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-proto/xproto
	x11-libs/libX11"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch ${FILESDIR}/${P}-m4_syntax.patch
	epatch ${FILESDIR}/${P}-no_gtk1.patch
	eautoreconf || die 'eautoreconf failed'
}

src_install () {
	emake DESTDIR=${D} install || die
	dodoc CREDITS ChangeLog README
}
