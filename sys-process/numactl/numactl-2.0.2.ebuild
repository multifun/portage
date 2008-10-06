# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/numactl/numactl-2.0.2.ebuild,v 1.1 2008/09/29 23:40:12 vapier Exp $

inherit base eutils toolchain-funcs

DESCRIPTION="Utilities and libraries for NUMA systems."
HOMEPAGE="http://oss.sgi.com/projects/libnuma/"
SRC_URI="ftp://oss.sgi.com/www/projects/libnuma/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="perl"

RDEPEND="perl? ( dev-lang/perl )"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" BENCH_CFLAGS="" || die
}

src_install() {
	emake install prefix="${D}/usr" || die
	# delete man pages provided by the man-pages package #238805
	rm -rf "${D}"/usr/share/man/man[25]
	doman *.8 || die # makefile doesnt get them all
	dodoc README TODO CHANGES DESIGN
	if ! use perl ; then
		rm "${D}"/usr/bin/numastat "${D}"/usr/share/man/man8/numastat.8 || die
	fi
}

src_test() {
	einfo "The only generically safe test is regress2."
	einfo "The other test cases require 2 NUMA nodes."
	cd test
	./regress2 || die "regress2 failed!"
}