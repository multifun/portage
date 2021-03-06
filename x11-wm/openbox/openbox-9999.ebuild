# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/openbox/openbox-9999.ebuild,v 1.4 2010/06/22 09:16:21 hwoarang Exp $

EAPI="2"
WANT_AUTOMAKE="1.9"
inherit autotools eutils git

DESCRIPTION="A standards compliant, fast, light-weight, extensible window manager"
HOMEPAGE="http://openbox.org/"
EGIT_REPO_URI="git://git.openbox.org/dana/openbox"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS=""
IUSE="imlib nls startup-notification"

RDEPEND="dev-libs/glib:2
	>=dev-libs/libxml2-2.0
	>=media-libs/fontconfig-2
	x11-libs/libXft
	x11-libs/libXrandr
	x11-libs/libXt
	>=x11-libs/pango-1.8[X]
	imlib? ( media-libs/imlib2 )
	nls? ( sys-devel/gettext )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	x11-libs/libXinerama"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	app-text/docbook2X
	dev-util/pkgconfig
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto
	x11-proto/xineramaproto"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-gnome-session-3.4.9.patch
	epatch "${FILESDIR}"/${PN}-as-needed.patch
	eautopoint
	eautoreconf
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable imlib imlib2) \
		$(use_enable nls) \
		$(use_enable startup-notification)
}

src_install() {
	dodir /etc/X11/Sessions
	echo "/usr/bin/openbox-session" > "${D}/etc/X11/Sessions/${PN}"
	fperms a+x /etc/X11/Sessions/${PN}

	emake DESTDIR="${D}" install || die "emake install failed"
}
