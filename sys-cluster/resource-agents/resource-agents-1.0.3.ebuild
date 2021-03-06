# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/resource-agents/resource-agents-1.0.3.ebuild,v 1.1 2010/06/21 07:37:28 xarthisius Exp $

EAPI="2"

MY_P="${P/resource-}"
inherit autotools multilib eutils base

DESCRIPTION="Resources pack for Heartbeat / Pacemaker"
HOMEPAGE="http://www.linux-ha.org/wiki/Resource_Agents"
SRC_URI="http://hg.linux-ha.org/agents/archive/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="sys-apps/iproute2
	sys-cluster/cluster-glue"
RDEPEND="${DEPEND}
	app-emulation/libvirt"

S="${WORKDIR}/Cluster-Resource-Agents-${MY_P}"

PATCHES=(
	"${FILESDIR}/1.0.3-docs.patch"
	"${FILESDIR}/1.0.3-respect_cflags.patch"
)

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-fatal-warnings \
		--localstatedir=/var \
		--docdir=/usr/share/doc/${PF} \
		--libdir=/usr/$(get_libdir) \
		--with-ocf-root=/usr/$(get_libdir)/ocf \
		$(use_enable doc) \
		--enable-libnet
}

src_install() {
	base_src_install
	rm -rf "${D}"/etc/init.d/ldirectord || die
}
