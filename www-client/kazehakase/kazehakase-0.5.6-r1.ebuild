# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/kazehakase/kazehakase-0.5.6-r1.ebuild,v 1.7 2010/06/13 02:29:02 nirbheek Exp $

inherit autotools eutils flag-o-matic

IUSE="hyperestraier migemo ruby ssl webkit"

DESCRIPTION="a browser with gecko engine like Epiphany or Galeon."
SRC_URI="mirror://sourceforge.jp/${PN}/33533/${P}.tar.gz"
HOMEPAGE="http://kazehakase.sourceforge.jp/"

SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
LICENSE="GPL-2"

DEPEND=">=x11-libs/gtk+-2.12
	|| (
		>=www-client/mozilla-firefox-2
		>=mail-client/thunderbird-2
		>=net-libs/xulrunner-1.8
	)
	ssl? ( >=net-libs/gnutls-1.2.0 )
	ruby? ( dev-ruby/ruby-gtk2 dev-ruby/ruby-gettext )
	hyperestraier? ( >=app-text/hyperestraier-1.2 )
	webkit? ( net-libs/webkit-gtk )"

RDEPEND="${DEPEND}
	migemo? ( app-text/migemo )"

DEPEND="${DEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.5.5-xulrunner19.patch
	epatch "${FILESDIR}"/${P}-gnutls-2.8.patch
	eautoreconf
}

src_compile() {
	local myconf

	# Bug 159949
	replace-flags -Os -O2

	myconf="${myconf} $(use_enable migemo)"
	use ruby || myconf="${myconf} --with-ruby=no --with-rgettext=no"
	use ssl || myconf="${myconf} --disable-ssl"

	econf ${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README* TODO*
}
