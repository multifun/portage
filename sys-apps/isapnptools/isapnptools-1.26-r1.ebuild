# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/isapnptools/isapnptools-1.26-r1.ebuild,v 1.3 2005/12/09 01:26:53 vapier Exp $

DESCRIPTION="Tools for configuring ISA PnP devices"
HOMEPAGE="http://www.roestock.demon.co.uk/isapnptools/"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/hardware/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"/src
	sed -i \
		-e "s/^static FILE\* o_file.*//" \
		-e "s/o_file/stdout/g" \
		-e "s/stdout_name/o_file_name/g" \
		pnpdump_main.c \
		|| die "sed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodir /sbin
	mv "${D}"/usr/sbin/isapnp "${D}"/sbin/ || die "couldnt relocate isapnp"

	dodoc AUTHORS ChangeLog README NEWS
	docinto txt
	dodoc doc/README*  doc/*.txt test/*.txt
	dodoc etc/isapnp.*

	newinitd "${FILESDIR}"/isapnp.rc isapnp
}
