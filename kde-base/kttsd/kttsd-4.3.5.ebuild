# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kttsd/kttsd-4.3.5.ebuild,v 1.4 2010/06/21 15:53:19 scarabeus Exp $

EAPI="2"

KMNAME="kdeaccessibility"

inherit kde4-meta

DESCRIPTION="KDE text-to-speech"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug epos festival flite freetts +handbook mbrola"

DEPEND="
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}
	epos? ( app-accessibility/epos )
	festival? ( app-accessibility/festival )
	flite? ( app-accessibility/flite )
	freetts? ( app-accessibility/freetts )
	mbrola? ( app-accessibility/mbrola )
"

src_configure() {
	mycmakeargs=(
		-DKDE4_KTTSD_COMMAND=ON
		-DKDE4_KTTSD_PHONON=ON
		$(cmake-utils_use alsa KDE4_KTTSD_ALSA)
		$(cmake-utils_use epos KDE4_KTTSD_EPOS)
		$(cmake-utils_use festival KDE4_KTTSD_FESTIVAL)
		$(cmake-utils_use flite KDE4_KTTSD_FLITE)
		$(cmake-utils_use freetts KDE4_KTTSD_FREETTS)
		$(cmake-utils_use mbrola KDE4_KTTSD_HADIFIX)
	)

	kde4-meta_src_configure
}
