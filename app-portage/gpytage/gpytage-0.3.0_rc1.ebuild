# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gpytage/gpytage-0.3.0_rc1.ebuild,v 1.5 2010/05/27 15:46:45 hwoarang Exp $

PYTHON_DEPEND="2:2.6"

inherit distutils

DESCRIPTION="GTK Utility to help manage Portage's user config files"
HOMEPAGE="https://gna.org/projects/gpytage"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.14"

pkg_setup() {
	python_set_active_version 2
}
