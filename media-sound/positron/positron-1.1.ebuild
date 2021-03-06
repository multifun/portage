# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/positron/positron-1.1.ebuild,v 1.13 2008/12/20 02:48:29 aballier Exp $

inherit distutils

DESCRIPTION="Synchronization manager for the Neuros Audio Computer (www.neurosaudio.com) portable music player."
HOMEPAGE="http://www.xiph.org/positron"
SRC_URI="http://www.xiph.org/positron/files/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
IUSE="vorbis"

DEPEND=">=dev-lang/python-2.2"
RDEPEND="${DEPEND}
	 vorbis? ( dev-python/pyvorbis )"

src_unpack() {
	distutils_src_unpack
	# install docs in /usr/share/doc/${PF}, bug #241290
	sed -i -e "s:share/doc/positron:share/doc/${PF}:" setup.py
}
