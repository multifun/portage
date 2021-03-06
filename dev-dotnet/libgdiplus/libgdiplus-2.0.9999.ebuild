# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/libgdiplus/libgdiplus-2.0.9999.ebuild,v 1.4 2010/03/30 11:50:46 ssuominen Exp $

EAPI=2

ESVN_REPO_URI="svn://anonsvn.mono-project.com/source/trunk/${PN}"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/svn-src/mono-${PV}"

inherit go-mono mono flag-o-matic subversion autotools

DESCRIPTION="Library for using System.Drawing with mono"
HOMEPAGE="http://www.go-mono.com/"

SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="cairo"

RDEPEND=">=dev-libs/glib-2.16
		>=media-libs/freetype-2.3.7
		>=media-libs/fontconfig-2.6
		media-libs/libpng
		x11-libs/libXrender
		x11-libs/libX11
		x11-libs/libXt
		>=x11-libs/cairo-1.8.4[X]
		media-libs/libexif
		>=media-libs/giflib-4.1.3
		media-libs/jpeg
		media-libs/tiff
		!cairo? ( >=x11-libs/pango-1.20 )"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare() {
	sed -i \
		-e 's/FONTCONFIG-CONFIG/FONTCONFIG_CONFIG/' \
		-e 's/FREETYPE-CONFIG/FREETYPE_CONFIG/' \
		configure.in || die 'configure.in not found'
	rm -rf cairo pixman
	go-mono_src_prepare
	sed -i -e 's:ungif:gif:g' configure || die
}

src_configure() {
	append-flags -fno-strict-aliasing
	go-mono_src_configure	--with-cairo=system			\
				$(use !cairo && printf %s --with-pango)	\
				|| die "configure failed"
}
