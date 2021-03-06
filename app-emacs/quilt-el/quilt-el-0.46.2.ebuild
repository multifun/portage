# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/quilt-el/quilt-el-0.46.2.ebuild,v 1.6 2009/10/02 23:26:06 tcunha Exp $

EAPI=2

inherit elisp eutils

DESCRIPTION="Quilt mode for Emacs"
HOMEPAGE="http://stakeuchi.sakura.ne.jp/dev/quilt-el/"
SRC_URI="http://stakeuchi.sakura.ne.jp/dev/quilt-el/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-util/quilt"

S="${WORKDIR}/${PN}"
SITEFILE=50${PN}-gentoo.el
DOCS="README changelog"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.45.4-tramp-recursion.patch"
	epatch "${FILESDIR}/${PN}-0.45.4-header-window.patch"
}
