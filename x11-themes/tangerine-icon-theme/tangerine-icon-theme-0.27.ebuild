# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tangerine-icon-theme/tangerine-icon-theme-0.27.ebuild,v 1.4 2010/04/02 16:17:27 ssuominen Exp $

EAPI=3
inherit gnome2-utils

DESCRIPTION="a derivative of the standard Tango theme, using a more orange approach"
HOMEPAGE="http://packages.ubuntu.com/gutsy/x11/tangerine-icon-theme"
SRC_URI="mirror://ubuntu/pool/universe/t/${PN}/${PN}_${PV}.tar.gz
	http://www.gentoo.org/images/gentoo-logo.svg"

LICENSE="CCPL-Attribution-ShareAlike-2.5 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="|| ( kde-base/oxygen-icons x11-themes/gnome-icon-theme )"
DEPEND="gnome-base/librsvg
	>=x11-misc/icon-naming-utils-0.8.90
	dev-util/intltool
	sys-devel/gettext"

RESTRICT="binchecks strip"

src_prepare() {
	sed -i \
		-e 's:lib/icon-naming-utils/icon:libexec/icon:' \
		Makefile || die

	cp "${DISTDIR}"/gentoo-logo.svg scalable/places/start-here.svg || die

	local res
	for res in 16 22 32; do
		rsvg -w ${res} -h ${res} scalable/places/start-here.svg \
			${res}x${res}/places/start-here.png || die
	done
}

src_compile() {
	emake index.theme || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
