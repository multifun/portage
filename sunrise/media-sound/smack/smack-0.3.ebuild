# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Drum synth, 100% sample free"
HOMEPAGE="http://smack.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-sound/om-0.2.0
		>=media-plugins/omins-0.2.0
		media-plugins/swh-plugins
		media-plugins/blop
		media-libs/ladspa-sdk
		media-libs/ladspa-cmt"
RDPEND="$DEPEND"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS THANKS README
}
