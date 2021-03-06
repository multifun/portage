# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmldoc/htmldoc-1.8.27-r1.ebuild,v 1.9 2010/06/01 13:26:43 josejx Exp $

inherit eutils

DESCRIPTION="Convert HTML pages into a PDF document"
SRC_URI="mirror://easysw/htmldoc/${PV}/${P}-source.tar.bz2"
HOMEPAGE="http://www.easysw.com/htmldoc/"

IUSE="fltk ssl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"

DEPEND="media-libs/jpeg
	media-libs/libpng
	fltk? ( >=x11-libs/fltk-1.0.11 )
	ssl? ( >=dev-libs/openssl-0.9.6e )"
RDEPEND="${DEPEND}"

# this needs to be figured out, since htmldoc looks for all three libs
# right now there's no virtual/ssl
#
#   --enable-openssl        use OpenSSL for SSL/TLS support, default=yes
#   --enable-gnutls         use GNU TLS for SSL/TLS support, default=yes
#   --enable-cdsassl        use CDSA for SSL/TLS support, default=yes

src_unpack() {
	unpack ${A}
	cd "${S}"
	# make sure not to use the libs htmldoc ships with
	mkdir foo ; mv jpeg foo/ ; mv png foo/ ; mv zlib foo/

	epatch "${FILESDIR}/${PN}-sscanf-overflows.patch"

	sed -i "s:^#define DOCUMENTATION \"\$prefix/share/doc/htmldoc\":#define DOCUMENTATION \"\$prefix/share/doc/${PF}/html\":" \
		configure
}

src_compile() {
	local myconf="$(use_enable ssl openssl) $(use_with fltk gui)"

	econf ${myconf} || die "econf failed"

	# Add missing -lfltk_images to LIBS
	use fltk && sed -i 's:-lfltk :-lfltk -lfltk_images :g' Makedefs

	emake || die "make failed"
}

src_install() {
	einstall bindir="${D}/usr/bin" || die "einstall failed"

	# Minor cleanups
	mv "${D}/usr/share/doc/htmldoc" "${D}/usr/share/doc/${PF}"
	dodir /usr/share/doc/${PF}/html
	mv "${D}"/usr/share/doc/${PF}/*.html "${D}/usr/share/doc/${PF}/html"
}
