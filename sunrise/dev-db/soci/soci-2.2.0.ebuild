# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A database access library for C++ that makes the illusion of embedding SQL queries in the regular C++ code."
HOMEPAGE="http://soci.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="Boost-1.0"
SLOT="0"
IUSE="debug firebird mysql postgres sqlite3 static"

RDEPEND="firebird? ( dev-db/firebird )
		mysql? ( virtual/mysql )
		postgres? ( dev-db/libpq )
		sqlite3? ( =dev-db/sqlite-3* )"
DEPEND="${RDEPEND}
		sys-devel/libtool"

src_compile() {
	local myconf
	use debug && myconf="--enable-debug=yes" || myconf="--enable-debug=no"
	econf ${myconf} \
		$(use_enable mysql backend-mysql) \
		$(use_enable sqlite3 backend-sqlite3) \
		$(use_enable postgres backend-postgresql) \
		$(use_enable firebird backend-firebird) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES README
	dohtml -r doc/*
}
