# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pino/pino-0.2.10.ebuild,v 1.1 2010/05/27 05:47:45 dev-zero Exp $

EAPI="3"

DESCRIPTION="Twitter and Identi.ca desktop client written in Vala"
HOMEPAGE="http://pino-app.appspot.com/ http://code.google.com/p/pino-twitter/"
SRC_URI="http://pino-twitter.googlecode.com/files/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug indicate"

RDEPEND=">=dev-libs/glib-2.14:2
	>=x11-libs/gtk+-2.10:2
	>=dev-libs/libgee-0.5.0
	x11-libs/libnotify
	net-libs/libsoup:2.4
	dev-libs/libxml2:2
	>=net-libs/webkit-gtk-1.1
	dev-libs/libunique
	app-text/gtkspell
	indicate? ( dev-libs/libindicate )"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.7.9
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool"

# TODO:
# write a patch (for CMakeLists.txt) to not ignore LINGUAS

DOCS="AUTHORS README"

src_configure() {
	local myconf=""
	use debug && myconf="--debug"

	if ! use indicate ; then
		# sabotage the detection since no configure option
		sed -i \
			-e 's|indicate|indicate-false|' \
			wscript || die "sed failed"
	fi

	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" \
	./waf --prefix=/usr \
		configure ${myconf} || die "./waf configure failed"
}

src_compile() {
	local myjobs=$(sed -n -e 's,.*\(-j[[:digit:]]\+\).*,\1,p' <<< ${MAKEOPTS})
	./waf ${myjobs} build || die "./waf configure failed"
}

src_install() {
	./waf \
		--destdir="${D}" \
		install || die "./waf install failed"

	rm -rf "${D}/usr/share/doc"
	dodoc ${DOCS}
}
