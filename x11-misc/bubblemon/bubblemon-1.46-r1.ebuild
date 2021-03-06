# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bubblemon/bubblemon-1.46-r1.ebuild,v 1.9 2010/03/20 17:00:03 ssuominen Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="A fun monitoring applet for your desktop, complete with swimming duck"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${PN}-dockapp-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}-dockapp-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gtk.patch \
		"${FILESDIR}"/${P}-asneeded.patch
}

src_compile() {
	tc-export CC
	emake GENTOO_CFLAGS="${CFLAGS}" || die "emake failed."
}

src_install() {
	dobin bubblemon || die

	dodoc ChangeLog README doc/Xdefaults.sample

	insinto /usr/share/${PN}
	doins misc/*.{xcf,wav} || die

	exeinto /usr/share/${PN}
	doexe misc/wakwak.sh || die
}
