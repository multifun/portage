# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmgtemp/wmgtemp-1.0.ebuild,v 1.2 2010/03/29 20:01:37 mr_bones_ Exp $

inherit eutils

DESCRIPTION="CPU and SYS temperature dockapp"
HOMEPAGE="http://www.fluxcode.net"
SRC_URI="http://www.fluxcode.net/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	=sys-apps/lm_sensors-3*
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:-Wall -g:\$(CFLAGS):" src/Makefile \
		|| die "sed failed."
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	dodoc BUGS CREDITS README TODO
	dobin src/wmgtemp
	doman wmgtemp.1
}
