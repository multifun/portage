# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/powermgmt-base/powermgmt-base-1.30.ebuild,v 1.1 2009/10/17 11:40:10 bangert Exp $

DESCRIPTION="Script to test whether computer is running on AC power"
HOMEPAGE="http://packages.debian.org/testing/utils/powermgmt-base"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}+nmu1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="sys-apps/gawk
	sys-apps/grep
	sys-apps/module-init-tools"

S="${WORKDIR}/${P}.1"

src_install() {
	dodir /sbin
	make DESTDIR="${D}" install || die
	doman man/acpi_available.1 man/apm_available.1 man/on_ac_power.1
	newdoc debian/powermgmt-base.README.Debian README
	dodoc debian/changelog
}
