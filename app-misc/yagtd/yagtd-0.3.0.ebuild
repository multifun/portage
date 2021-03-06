# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/yagtd/yagtd-0.3.0.ebuild,v 1.1 2009/12/02 20:41:05 bangert Exp $

EAPI="2"

inherit distutils

DESCRIPTION="CLI todo list manager based on the 'Getting Things Done' philosophy."
HOMEPAGE="https://gna.org/projects/yagtd/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	#fix doc install location
	sed -i -e "s:\/doc\/yagtd:\/doc\/${P}:g" setup.py || die
}

src_install() {
	distutils_src_install
	dosym /usr/bin/yagtd.py /usr/bin/yagtd
}
