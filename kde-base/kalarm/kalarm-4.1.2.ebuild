# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalarm/kalarm-4.1.2.ebuild,v 1.1 2008/10/02 06:33:48 jmbsvicetto Exp $

EAPI="2"

KMNAME=kdepim
inherit kde4-meta

DESCRIPTION="Personal alarm message, command and email scheduler for KDE"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=kde-base/libkdepim-${PV}:${SLOT}"

RDEPEND="${DEPEND}"

KMEXTRACTONLY="kmail
	libkdepim"
