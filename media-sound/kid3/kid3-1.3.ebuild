# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kid3/kid3-1.3.ebuild,v 1.2 2009/11/23 13:30:49 spatz Exp $

EAPI=2
inherit kde4-base

DESCRIPTION="A simple ID3 tag editor for QT/KDE."
HOMEPAGE="http://kid3.sourceforge.net/"
SRC_URI="mirror://sourceforge/kid3/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="flac mp3 mp4 musicbrainz +taglib vorbis"

RDEPEND="mp3? ( media-libs/id3lib )
	taglib? ( media-libs/taglib )
	mp4? ( media-libs/libmp4v2 )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac[cxx] )
	musicbrainz? ( media-libs/musicbrainz:3
		media-libs/tunepimp )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-compile-without-vorbis.patch"

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with taglib)
		$(cmake-utils_use_with mp4 MP4V2)
		$(cmake-utils_use_with mp3 ID3LIB)
		$(cmake-utils_use_with musicbrainz TUNEPIMP)
		$(cmake-utils_use_with vorbis)
		$(cmake-utils_use_with flac)"

	kde4-base_src_configure
}
