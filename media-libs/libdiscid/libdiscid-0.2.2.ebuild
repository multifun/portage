# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdiscid/libdiscid-0.2.2.ebuild,v 1.5 2010/01/21 21:49:56 abcd Exp $

DESCRIPTION="Client library to create MusicBrainz enabled tagging applications"
HOMEPAGE="http://musicbrainz.org/products/libdiscid/"
SRC_URI="http://users.musicbrainz.org/~matt/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS="README AUTHORS examples/discid.c"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ${DOCS} || die
}
