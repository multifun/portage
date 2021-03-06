# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/iwl4965-ucode/iwl4965-ucode-228.57.2.21.ebuild,v 1.7 2010/01/09 11:16:36 hanno Exp $

MY_PN="iwlwifi-4965-ucode"

DESCRIPTION="Intel (R) Wireless WiFi Link 4965AGN ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_PN}-${PV}.tgz"

LICENSE="ipw3945"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="|| ( >=sys-fs/udev-096 >=sys-apps/hotplug-20040923 )"

S=${WORKDIR}/${MY_PN}-${PV}

src_compile() {
	true;
}

src_install() {
	insinto /lib/firmware
	doins iwlwifi-4965-2.ucode || die
	dodoc README* || die "dodoc failed"
}

pkg_postinst() {
	elog "Due to ucode API change this version of ucode works only with kernels"
	elog ">=2.6.27. If you need ucode for older versions please install it with"
	elog "emerge net-wireless/${PN}:0"
	elog "For more information take a look at bugs.gentoo.org/235007"
}
