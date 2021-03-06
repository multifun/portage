# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/howm/howm-1.3.7-r1.ebuild,v 1.1 2010/01/31 19:45:22 ulm Exp $

EAPI=3

inherit elisp

DESCRIPTION="Note-taking tool on Emacs"
HOMEPAGE="http://howm.sourceforge.jp/"
SRC_URI="http://howm.sourceforge.jp/a/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf --with-docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_compile() {
	emake -j1 </dev/null || die "emake failed"
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LISPDIR="${EPREFIX}${SITELISP}/${PN}" \
		install </dev/null \
		|| die "emake install failed"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	dodoc ChangeLog || die "dodoc failed"
}

pkg_postinst() {
	elisp-site-regen
	elog "site-gentoo.el does no longer define global keybindings for howm."
	elog "Add the following line to ~/.emacs for the previous behaviour:"
	elog "  (require 'howm)"
}
