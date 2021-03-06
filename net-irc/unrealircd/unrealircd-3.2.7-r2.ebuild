# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/unrealircd/unrealircd-3.2.7-r2.ebuild,v 1.8 2009/11/16 14:41:04 rbu Exp $

EAPI="2"

inherit eutils ssl-cert versionator multilib

MY_P=Unreal${PV}

DESCRIPTION="aimed to be an advanced (not easy) IRCd"
HOMEPAGE="http://www.unrealircd.com/"
SRC_URI="http://unreal.brueggisite.de/${MY_P}.tar.gz
	http://www.blurryfox.com/unreal/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~mips ppc sparc x86 ~x86-fbsd"
IUSE="hub ipv6 ssl zlib curl prefixaq showlistmodes"

RDEPEND="ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	curl? ( net-misc/curl[ares,-ipv6] )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S="${WORKDIR}/Unreal${PV}"

pkg_setup() {
	enewuser unrealircd
}

src_prepare() {
	sed -i \
		-e "s:ircd\.pid:/var/run/unrealircd/ircd.pid:" \
		-e "s:ircd\.log:/var/log/unrealircd/ircd.log:" \
		-e "s:debug\.log:/var/log/unrealircd/debug.log:" \
		-e "s:ircd\.tune:/var/lib/unrealircd/ircd.tune:" \
		include/config.h
}

src_configure() {
	local myconf=""
	use curl     && myconf="${myconf} --enable-libcurl=/usr"
	use ipv6     && myconf="${myconf} --enable-inet6"
	use zlib     && myconf="${myconf} --enable-ziplinks"
	use hub      && myconf="${myconf} --enable-hub"
	use ssl      && myconf="${myconf} --enable-ssl"
	use prefixaq && myconf="${myconf} --enable-prefixaq"
	use showlistmodes && myconf="${myconf} --with-showlistmodes"

	econf \
		--with-listen=5 \
		--with-dpath="${D}"/etc/unrealircd \
		--with-spath=/usr/bin/unrealircd \
		--with-nick-history=2000 \
		--with-sendq=3000000 \
		--with-bufferpool=18 \
		--with-hostname=$(hostname -f) \
		--with-permissions=0600 \
		--with-fd-setsize=1024 \
		--enable-dynamic-linking \
		${myconf} \
		|| die "econf failed"

	sed -i \
		-e "s:${D}::" \
		include/setup.h \
		ircdcron/ircdchk
}

src_compile() {
	emake MAKE=make IRCDDIR=/etc/unrealircd || die "emake failed"
}

src_install() {
	keepdir /var/{lib,log,run}/unrealircd

	newbin src/ircd unrealircd

	exeinto /usr/$(get_libdir)/unrealircd/modules
	doexe src/modules/*.so

	dodir /etc/unrealircd
	dosym /var/lib/unrealircd /etc/unrealircd/tmp

	insinto /etc/unrealircd
	doins {badwords.*,help,spamfilter,dccallow}.conf
	newins doc/example.conf unrealircd.conf

	insinto /etc/unrealircd/aliases
	doins aliases/*.conf
	insinto /etc/unrealircd/networks
	doins networks/*.network

	sed -i \
		-e s:src/modules:/usr/$(get_libdir)/unrealircd/modules: \
		-e s:ircd\\.log:/var/log/unrealircd/ircd.log: \
		"${D}"/etc/unrealircd/unrealircd.conf

	dodoc \
		Changes Donation Unreal.nfo networks/makenet \
		ircdcron/{ircd.cron,ircdchk} \
		|| die "dodoc failed"
	dohtml doc/*.html

	newinitd "${FILESDIR}"/unrealircd.rc unrealircd
	newconfd "${FILESDIR}"/unrealircd.confd unrealircd

	fperms 700 /etc/unrealircd
	chown -R unrealircd "${D}"/{etc,var/{lib,log,run}}/unrealircd
}

pkg_postinst() {
	# Move docert call from scr_install() to install_cert in pkg_postinst for
	# bug #201682
	use ssl && \
		if [[ ! -f "${ROOT}"/etc/unrealircd/server.cert.key ]]; then
			install_cert /etc/unrealircd/server.cert
			chown unrealircd "${ROOT}"/etc/unrealircd/server.cert.*
			ln -snf server.cert.key "${ROOT}"/etc/unrealircd/server.key.pem
		fi

	elog
	elog "UnrealIRCd will not run until you've set up /etc/unrealircd/unrealircd.conf"
	elog
	elog "You can find example cron scripts here:"
	elog "   /usr/share/doc/${PF}/"
	elog "   /usr/share/doc/${PF}/"
	elog
	elog "You can also use /etc/init.d/unrealircd to start at boot"
	elog
}
