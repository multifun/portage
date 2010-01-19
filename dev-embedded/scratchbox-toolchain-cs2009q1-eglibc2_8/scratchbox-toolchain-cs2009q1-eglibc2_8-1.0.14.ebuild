# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/scratchbox-toolchain-cs2009q1-eglibc2_8/scratchbox-toolchain-cs2009q1-eglibc2_8-1.0.14.ebuild,v 1.3 2010/01/18 13:04:04 flameeyes Exp $

SBOX_GROUP="sbox"

ARMV=${PV}-7
I486V=${PV}-4

DESCRIPTION="A cross-compilation toolkit designed to make embedded Linux application development easier."
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/stable/tarball/${PN/_/.}-armv7-${ARMV}-i386.tar.gz
	http://scratchbox.org/download/files/sbox-releases/stable/tarball/${PN/_/.}-i486-${I486V}-i386.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Stripping BREAKS scratchbox, it runs in a chroot and is pre-stripped when needed (bug #296294)
RESTRICT="strip"

DEPEND=""
RDEPEND="=dev-embedded/scratchbox-1.0*"

TARGET_DIR="/opt/scratchbox"

S=${WORKDIR}/scratchbox

src_install() {
	dodir ${TARGET_DIR}
	cp -pRP * "${D}/${TARGET_DIR}"
}
