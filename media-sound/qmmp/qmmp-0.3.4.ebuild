# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qmmp/qmmp-0.3.4.ebuild,v 1.1 2010/04/19 14:25:31 hwoarang Exp $

EAPI="2"

inherit cmake-utils
[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="Qt4-based audio player with winamp/xmms skins support"
HOMEPAGE="http://qmmp.ylsoftware.com/index_en.php"
if [ "$PV" != "9999" ]; then
	SRC_URI="http://qmmp.ylsoftware.com/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI=""
	ESVN_REPO_URI="http://qmmp.googlecode.com/svn/trunk/qmmp/"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="aac +alsa +dbus bs2b ffmpeg flac jack libsamplerate +mad modplug musepack oss projectm pulseaudio scrobbler sndfile +vorbis wavpack"

RDEPEND="x11-libs/qt-gui:4[qt3support]
	media-libs/taglib
	alsa? ( media-libs/alsa-lib )
	bs2b? ( media-libs/libbs2b )
	dbus? ( sys-apps/dbus )
	aac? ( media-libs/faad2 )
	flac? ( media-libs/flac )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	musepack? ( >=media-sound/musepack-tools-444 )
	modplug? ( >=media-libs/libmodplug-0.8.4 )
	vorbis? ( media-libs/libvorbis
		media-libs/libogg )
	jack? ( media-sound/jack-audio-connection-kit
		media-libs/libsamplerate )
	ffmpeg? ( media-video/ffmpeg )
	projectm? ( media-libs/libprojectm )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	wavpack? ( media-sound/wavpack )
	scrobbler? ( net-misc/curl )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog README"

CMAKE_IN_SOURCE_BUILD="1"

qmmp_use_enable() {
	# uses completely non standard cmake options...
	if use ${1}; then
		echo "-DUSE_${2}:BOOL=TRUE"
	else
		echo "-DUSE_${2}:BOOL=FALSE"
	fi
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(qmmp_use_enable alsa ALSA)
		$(qmmp_use_enable aac AAC)
		$(qmmp_use_enable bs2b BS2B)
		$(qmmp_use_enable dbus DBUS)
		$(qmmp_use_enable ffmpeg FFMPEG)
		$(qmmp_use_enable flac FLAC)
		$(qmmp_use_enable jack JACK)
		$(qmmp_use_enable mad MAD)
		$(qmmp_use_enable modplug MODPLUG)
		$(qmmp_use_enable musepack MPC)
		$(qmmp_use_enable oss OSS)
		$(qmmp_use_enable projectm PROJECTM)
		$(qmmp_use_enable pulseaudio PULSE)
		$(qmmp_use_enable scrobbler SCROBBLER)
		$(qmmp_use_enable sndfile SNDFILE)
		$(qmmp_use_enable libsamplerate SRC)
		$(qmmp_use_enable vorbis VORBIS)
		$(qmmp_use_enable wavpack WAVPACK)"

	cmake-utils_src_configure
}
