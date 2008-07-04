# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#$Header:$

inherit eutils

DESCRIPTION="Database Designer"
HOMEPAGE="http://www.fabforce.net"
SRC_URI="http://downloads.mysql.com/DBDesigner4/DBDesigner${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND="x11-libs/qt sys-libs/lib-compat x11-libs/kylixlibs3-borqt"
RDEPEND="${DEPEND}"

S=${WORKDIR}/DBDesigner4
INSTALLDIR=/opt/DBDesigner4


src_install()
{
	insinto "${INSTALLDIR}"
	doins -r "${S}"/*
	ebegin "Fixing permissions of DBDesigner4 executable"
	fperms 111 "${INSTALLDIR}"/DBDesigner4
	eend
	ebegin "Fixing permissions of startdbd executable"
	fperms 111 "${INSTALLDIR}"/startdbd
	eend
	cd "${D}"/"${INSTALLDIR}"/Linuxlib
	einfo "Creating symlinks"
	ln -s "${D}"/opt/kylix3/libborqt-6.9-qt2.3.so libqt.so.2
	ln -s bplrtl.so.6.9.0 bplrtl.so.6.9
	ln -s dbxres.en.1.0 dbxres.en.1
	ln -s libmidas.so.1.0 libmidas.so.1
	ln -s libmysqlclient.so.10.0.0 libmysqlclient.so
	ln -s libqtintf-6.9.0-qt2.3.so libqtintf-6.9-qt2.3.so
	ln -s libsqlmy23.so.1.0 libsqlmy23.so
	ln -s libsqlmy23.so libsqlmy.so
	ln -s libsqlora.so.1.0 libsqlora.so
	ln -s libDbxSQLite.so.2.8.5 libDbxSQLite.so
	ln -s liblcms.so.1.0.9 liblcms.so
	ln -s libpng.so.2.1.0.12 libpng.so.2
	ln -s libstdc++.so.5.0.0 libstdc++.so.5
	dobin "${S}"/startdbd
	ebegin "Creating Icons"
	newicon "${S}"/Gfx/Icon48.xpm Icon48.xpm
	make_desktop_entry startdbd DBDesigner4 Icon48.xpm "Applications;Development"
	eend
        ewarn ""
        ewarn "Bugs report : gentoo@silverarrow.gr"
        ewarn ""
	ewarn ""
        ewarn "DBDesigner4 is now installed. Use startdbd command to run it"
        ewarn ""
}
