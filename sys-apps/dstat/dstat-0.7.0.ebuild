# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dstat/dstat-0.6.9-r1.ebuild,v 1.1 2009/11/25 13:43:09 rbu Exp $

EAPI=2
inherit python eutils

DESCRIPTION="Dstat is a versatile replacement for vmstat, iostat and ifstat"
HOMEPAGE="http://dag.wieers.com/home-made/dstat/"
SRC_URI="http://dag.wieers.com/home-made/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND="virtual/python"
DEPEND=""

src_compile() {
	# this disables unnecessary doc regeneration that depends upon asciidoc
	return 0
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO examples/{mstat,read}.py docs/*.txt || die "dodoc failed"
	dohtml docs/*.html || die "dohtml failed"
}

pkg_postinst() {
	python_mod_optimize /usr/share/dstat
}

pkg_postrm() {
	python_mod_cleanup /usr/share/dstat
}
