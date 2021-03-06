# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libferrisstreams/libferrisstreams-0.5.0.ebuild,v 1.9 2008/07/11 07:59:01 remi Exp $

inherit flag-o-matic

DESCRIPTION="Loki Standard C++ IOStreams extensions"
HOMEPAGE="http://witme.sourceforge.net/libferris.web/"
SRC_URI="mirror://sourceforge/witme/ferrisstreams-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND=">=dev-libs/STLport-4.6.2-r1
	=dev-libs/libsigc++-1.2*
	>=dev-libs/ferrisloki-2.1.0
	>=dev-libs/glib-2"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

S=${WORKDIR}/ferrisstreams-${PV}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
