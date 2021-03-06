# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/adns-python/adns-python-1.2.1.ebuild,v 1.10 2009/02/04 13:21:42 patrick Exp $

inherit distutils eutils

DESCRIPTION="Python bindings for ADNS"
HOMEPAGE="http://code.google.com/p/adns-python/"
SRC_URI="http://adns-python.googlecode.com/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=net-libs/adns-1.3"
RDEPEND="${DEPEND}"
