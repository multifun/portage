# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/eiskaltdcpp/eiskaltdcpp-2.0.2.ebuild,v 1.2 2010/06/11 16:41:24 pva Exp $

EAPI=2

LANGS="be en fr hu pl ru"
inherit qt4-r2 cmake-utils

DESCRIPTION="Qt4 based client for DirectConnect and ADC protocols, based on DC++ library"
HOMEPAGE="http://eiskaltdc.googlecode.com/"
SRC_URI="http://${PN/pp/}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell"

RDEPEND=">=x11-libs/qt-gui-4.4.0:4[dbus]
	net-libs/libupnp
	dev-libs/boost
	app-arch/bzip2
	sys-libs/zlib
	dev-libs/openssl
	virtual/libiconv
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog.txt"

src_configure() {
	# linguas
	local langs
	for lang in ${LANGS}; do
		use linguas_${lang} && langs+="${lang} "
	done

	local mycmakeargs=(
		-DFREE_SPACE_BAR_C="1"
		"$(cmake-utils_use spell USE_ASPELL)"
		-Dlinguas="${langs}"
	)
	cmake-utils_src_configure
}
