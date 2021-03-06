# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/qla-fc-firmware/qla-fc-firmware-20071207.ebuild,v 1.3 2008/03/30 04:12:35 mr_bones_ Exp $

DESCRIPTION="QLogic Linux Fibre Channel HBA Firmware for ql2xxx cards"
HOMEPAGE="ftp://ftp.qlogic.com/outgoing/linux/firmware/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="qlogic-fibre-channel-firmware"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

# really depends on absolutely nothing
DEPEND=""
RDEPEND=""

FW_BASENAME="ql2100_fw.bin ql2200_fw.bin ql2300_fw.bin ql2322_fw.bin ql2400_fw.bin ql2500_fw.bin ql6312_fw.bin"

src_install() {
	# We must install this, say QLogic's people.
	# They have claimed to me that the /license/ directory isn't sufficient, as
	# there is no guarantee it will be on a system - and it would not be in any
	# binpkg either. If you do something else with the firmware blobs, you are
	# thus strongly encouraged to keep a copy of the LICENSE file with them on
	# the system.
	dodoc LICENSE
	dodoc README.gentoo CURRENT_VERSIONS
	insinto /lib/firmware
	# some older firmware are always provided by upstream
	# for reasons documented in CURRENT_VERSIONS
	# When multiple types are available for a single version, we should provide a
	# way to select between them
	for f in ${FW_BASENAME} ; do
		doins ${f}.*
		latest_f="$(ls ${f}.* | sort -n | tail -n1)"
		dosym ${latest_f} /lib/firmware/${f}
	done
}
