# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-2.2.2.ebuild,v 1.4 2010/04/10 23:09:02 hwoarang Exp $

EAPI="2"
inherit confutils qt4-r2 versionator

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+X geoip libnotify"

# boost version so that we always have thread support
CDEPEND="net-libs/rb_libtorrent
	x11-libs/qt-core:4
	X? ( x11-libs/qt-gui:4
		libnotify? ( x11-libs/qt-gui:4[glib] ) )
	>=dev-libs/boost-1.34.1"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}
	>=dev-lang/python-2.3
	geoip? ( dev-libs/geoip )
	libnotify? ( x11-libs/libnotify )"

DOCS="AUTHORS Changelog NEWS README TODO"

pkg_setup() {
	confutils_use_depend_all libnotify X
}

src_prepare() {
	# Respect LDFLAGS
	sed -i -e 's/-Wl,--as-needed/$(LDFLAGS)/g' src/src.pro
	qt4-r2_src_prepare
}

src_configure() {
	local myconf
	use X         || myconf+=" --disable-gui"
	use geoip     || myconf+=" --disable-geoip-database"
	use libnotify || myconf+=" --disable-libnotify"

	# slotted boost detection, bug #309415
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.34.1")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	myconf+=" --with-libboost-inc=/usr/include/boost-${BOOST_VER}"

	# econf fails, since this uses qconf
	./configure --prefix=/usr --qtdir=/usr ${myconf} || die "configure failed"
	eqmake4

	# link to the correct slotted boost version, bug #309415
	sed -i "s/-mt/-mt-${BOOST_VER}/g" conf.pri
}
