# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/catdoc/catdoc-0.94.2-r2.ebuild,v 1.1 2010/05/03 21:43:22 ssuominen Exp $

EAPI=3
WANT_AUTOMAKE=none

inherit autotools eutils

DESCRIPTION="A convertor for Microsoft Word, Excel and RTF Files to text"
HOMEPAGE="http://www.wagner.pp.ru/~vitus/software/catdoc/"
SRC_URI="http://ftp.wagner.pp.ru/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

IUSE="tk"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="tk? ( >=dev-lang/tk-8.1 )"

DOCS="CODING.STD CREDITS NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}/${P}-flags.patch"
	epatch "${FILESDIR}/${P}+autoconf-2.63.patch"

	# Fix for case-insensitive filesystems
	echo ".PHONY: all install clean distclean dist" >> Makefile.in

	eautoconf
}

src_configure() {
	econf --with-install-root="${D}" \
		$(use_with tk wish "${EPREFIX}"/usr/bin/wish) \
		$(use_with !tk wordview)
}

src_compile() {
	emake LIB_DIR=/usr/share/catdoc || die
}

src_install() {
	emake -j1 mandir="${EPREFIX}"/usr/share/man/man1 install || die

	if [[ -e ${D}/usr/bin/xls2csv ]]; then
		einfo "Renaming xls2csv to xls2csv-${PN} because of bug 314657."
		mv -vf "${D}"/usr/bin/xls2csv "${D}"/usr/bin/xls2csv-${PN} || die
	fi

	dodoc ${DOCS}
}
