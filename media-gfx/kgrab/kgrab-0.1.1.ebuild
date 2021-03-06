# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kgrab/kgrab-0.1.1.ebuild,v 1.1 2010/02/21 17:44:17 ssuominen Exp $

EAPI=2
KDE_MINIMAL=4.4
KDE_LINGUAS="ar be bg ca cs da de el en_GB eo es et fi fr ga gl he hi hne hr hu
is it ja km lt lv mai nb nds nl nn pa pl pt pt_BR ro se sk sv th tr uk vi zh_CN
zh_TW"
inherit kde4-base

KDE_VERSION=4.4.0
MY_P=${P}-kde${KDE_VERSION}

DESCRIPTION="A screen grabbing utility"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/stable/${KDE_VERSION}/src/extragear/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 FDL-1.2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/libX11
	x11-libs/libXext"

S=${WORKDIR}/${MY_P}
