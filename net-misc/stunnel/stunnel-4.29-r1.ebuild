# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/stunnel/stunnel-4.29-r1.ebuild,v 1.2 2010/06/21 00:46:41 ramereth Exp $

EAPI="2"

inherit autotools ssl-cert eutils

DESCRIPTION="TLS/SSL - Port Wrapper"
HOMEPAGE="http://stunnel.mirt.net/"
SRC_URI="http://www.stunnel.org/download/stunnel/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86"
IUSE="ipv6 selinux tcpd xforward"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )
	>=dev-libs/openssl-0.9.8k"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-stunnel )"

pkg_setup() {
	enewgroup stunnel
	enewuser stunnel -1 -1 -1 stunnel
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.21-libwrap.patch"
	use xforward && epatch "${FILESDIR}/${P}-x-forwarded-for.patch"
	eautoreconf

	# Hack away generation of certificate
	sed -i -e "s/^install-data-local:/do-not-run-this:/" \
		tools/Makefile.in || die "sed failed"
}

src_configure() {
	econf $(use_enable ipv6) \
		$(use_enable tcpd libwrap) || die "econf died"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}"/usr/share/doc/${PN}
	rm -f "${D}"/etc/stunnel/stunnel.conf-sample "${D}"/usr/bin/stunnel3 \
		"${D}"/usr/share/man/man8/stunnel.{fr,pl}.8

	# The binary was moved to /usr/bin with 4.21,
	# symlink for backwards compatibility
	dosym ../bin/stunnel /usr/sbin/stunnel

	dodoc AUTHORS BUGS CREDITS PORTS README TODO ChangeLog
	dohtml doc/stunnel.html doc/en/VNC_StunnelHOWTO.html tools/ca.html \
		tools/importCA.html

	insinto /etc/stunnel
	doins "${FILESDIR}"/stunnel.conf
	newinitd "${FILESDIR}"/stunnel.initd stunnel

	keepdir /var/run/stunnel
	fowners stunnel:stunnel /var/run/stunnel
}

pkg_postinst() {
	if [ ! -f "${ROOT}"/etc/stunnel/stunnel.key ]; then
		install_cert /etc/stunnel/stunnel
		chown stunnel:stunnel "${ROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
		chmod 0640 "${ROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
	fi

	einfo "If you want to run multiple instances of stunnel, create a new config"
	einfo "file ending with .conf in /etc/stunnel/. **Make sure** you change "
	einfo "\'pid= \' with a unique filename."
}
