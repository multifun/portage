# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/qconf/qconf-1.5_pre717.ebuild,v 1.8 2010/06/22 14:23:56 jer Exp $

EAPI="2"

inherit multilib

DESCRIPTION="./configure like generator for qmake-based projects"
HOMEPAGE="http://delta.affinix.com/qconf/"
SRC_URI="http://delta.affinix.com/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-libs/qt-core"
RDEPEND="${DEPEND}"

src_configure() {
	# Fake ./configure. Fails on unknown options
	./configure \
		--prefix=/usr/ \
		--qtdir=/usr/$(get_libdir)/ || die "./configure failed"

	[ ! -f Makefile ] && die "./configure failed"
}

src_install() {
	dobin qconf || die
	dodoc README TODO || die
	insinto /usr/share/${PN}
	doins -r conf modules
	insinto /usr/share/doc/${PF}/examples
	doins examples/*
}
