# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/nilfs-utils/nilfs-utils-2.0.16.ebuild,v 1.1 2010/03/13 07:00:31 matsuu Exp $

EAPI=2

DESCRIPTION="A New Implementation of a Log-structured File System for Linux"
HOMEPAGE="http://www.nilfs.org/"
SRC_URI="http://www.nilfs.org/download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="sys-libs/e2fsprogs-libs"
DEPEND="${DEPEND}
	sys-kernel/linux-headers"

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README || die
}
