# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/phonon-kde/phonon-kde-4.3.5.ebuild,v 1.5 2010/06/21 15:52:59 scarabeus Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"

KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="alsa debug pulseaudio +xine"

DEPEND="
	media-sound/phonon[xine?]
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	!=media-sound/phonon-4.4_pre*
"
RDEPEND="${DEPEND}"

add_blocker phonon-xine

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.4-optional-alsa.patch
)

src_prepare() {
	kde4-meta_src_prepare

	# Don't build tests - they require OpenGL
	sed -e 's/add_subdirectory(tests)//' \
		-i phonon/CMakeLists.txt || die "Failed to disable tests"

	# Disable automagic
	sed -e 's/find_package(Xine)/macro_optional_find_package(Xine)/' \
		-i phonon/kcm/xine/CMakeLists.txt || die "Failed to make xine optional"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with pulseaudio PulseAudio)
		$(cmake-utils_use_with xine)
	)

	kde4-meta_src_configure
}
