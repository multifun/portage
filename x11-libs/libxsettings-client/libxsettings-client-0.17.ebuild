# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxsettings-client/libxsettings-client-0.17.ebuild,v 1.4 2010/02/07 16:22:26 jer Exp $

GPE_TARBALL_SUFFIX="bz2"

inherit gpe autotools

DESCRIPTION="XSETTINGS client code"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sh ~x86 ~hppa"

DOCS="ChangeLog"
IUSE=""

RDEPEND="${RDEPEND}"

DEPEND="${DEPEND}
	${RDEPEND}
	x11-proto/xproto
	x11-libs/libX11"

src_unpack() {
	gpe_src_unpack "$@"

	sed -i -e \
		's;INCLUDES = -I $(includedir);INCLUDES = -I '$ROOT'/$(includedir);' \
		Makefile.am || die "sed failed"
	sed -i -e '/^CFLAGS="-Os -Wall"/d' configure.ac || die "sed failed"
	eautoreconf
}
