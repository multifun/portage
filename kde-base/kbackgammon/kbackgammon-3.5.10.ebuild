# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kbackgammon/kbackgammon-3.5.10.ebuild,v 1.5 2009/06/18 04:20:53 jer Exp $
KMNAME=kdegames
EAPI="1"
inherit kde-meta

DESCRIPTION="A Backgammon program for KDE"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
DEPEND=">=kde-base/libkdegames-${PV}:${SLOT}"
RDEPEND="${DEPEND}"

KMEXTRACTONLY=libkdegames
KMCOPYLIB="libkdegames libkdegames"
