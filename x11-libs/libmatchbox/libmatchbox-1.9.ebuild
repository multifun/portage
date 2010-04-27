# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libmatchbox/libmatchbox-1.9.ebuild,v 1.9 2010/04/26 15:17:37 yvasilev Exp $

inherit eutils

DESCRIPTION="The Matchbox Library."
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~x86"
IUSE="debug doc jpeg pango png test truetype X xsettings"

RDEPEND="x11-libs/libXext
	truetype? ( x11-libs/libXft )
	pango? ( x11-libs/pango )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	xsettings? ( x11-libs/libxsettings-client )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"

pkg_setup() {
	# Bug #138135
	if use truetype && use pango; then
		ewarn "You have both the truetype and pango USE flags set, pango"
		ewarn "overrides and disables the XFT support truetype enables."
		ewarn "If this isn't what you intended you should stop the build!"
		ebeep 3
		epause 3
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-libpng14.patch
	elibtoolize
}

src_compile() {
	econf	$(use_enable debug) \
		$(use_enable doc doxygen-docs) \
		$(use_enable truetype xft) \
		$(use_enable pango) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable xsettings) \
		$(use_with X x) \
		$(use_enable test unit-tests) \
		|| die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog INSTALL NEWS README
	use doc && dohtml doc/html/*
}
