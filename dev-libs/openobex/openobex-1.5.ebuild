# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openobex/openobex-1.5.ebuild,v 1.12 2010/06/11 12:13:42 ssuominen Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="An implementation of the OBEX protocol used for transferring data to mobile devices"
HOMEPAGE="http://sourceforge.net/projects/openobex/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 sparc x86"
IUSE="bluetooth debug irda syslog usb"

RDEPEND="bluetooth? ( net-wireless/bluez )
	usb? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-use-flags.patch
	eautoreconf
}

src_configure() {
	econf \
		--enable-apps \
		$(use_enable irda) \
		$(use_enable bluetooth) \
		$(use_enable usb) \
		$(use_enable debug) \
		$(use_enable debug dump) \
		$(use_enable syslog)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README AUTHORS NEWS ChangeLog
}
