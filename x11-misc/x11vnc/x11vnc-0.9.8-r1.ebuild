# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/x11vnc/x11vnc-0.9.8-r1.ebuild,v 1.3 2009/11/21 10:42:30 swegener Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A VNC server for real X displays"
HOMEPAGE="http://www.karlrunge.com/x11vnc/"
SRC_URI="mirror://sourceforge/libvncserver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="fbcon +jpeg +zlib threads ssl crypt v4l xinerama avahi system-libvncserver"

RDEPEND="system-libvncserver? ( >=net-libs/libvncserver-0.9.7[threads=,jpeg=,zlib=] )
	!system-libvncserver? (
		zlib? ( sys-libs/zlib )
		jpeg? ( media-libs/jpeg )
	)
	ssl? ( dev-libs/openssl )
	avahi? ( >=net-dns/avahi-0.6.4 )
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXdamage
	x11-libs/libXext"

DEPEND="${RDEPEND}
	x11-libs/libXt
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/inputproto
	x11-proto/trapproto
	x11-proto/recordproto
	x11-proto/xproto
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}/${P}-xshm-header-fix.patch"
}

pkg_setup() {
	if use avahi && ! use threads
	then
		ewarn "Non-native avahi support has been enabled."
		ewarn "Native avahi support can be enabled by also enabling the threads USE flag."
	fi
}

src_configure() {
	econf \
		$(use_with system-libvncserver) \
		$(use_with avahi) \
		$(use_with xinerama) \
		$(use_with ssl) \
		$(use_with ssl crypto) \
		$(use_with crypt) \
		$(use_with v4l) \
		$(use_with jpeg) \
		$(use_with zlib) \
		$(use_with threads pthread) \
		$(use_with fbcon fbdev) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc x11vnc/{ChangeLog,README}
}
