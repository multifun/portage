# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/prctl/prctl-1.5.ebuild,v 1.3 2008/07/14 19:04:18 armin76 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Tool to query and modify process behavior"
HOMEPAGE="http://sourceforge.net/projects/prctl/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ia64"
IUSE=""
DEPEND="sys-apps/groff"

src_compile() {
	econf || die
	emake \
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	# emake doesn't work
	dobin prctl
	doman prctl.1
	dodoc Changelog
}
