# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langlithuanian/texlive-langlithuanian-2009.ebuild,v 1.4 2010/02/02 21:21:22 abcd Exp $

TEXLIVE_MODULE_CONTENTS="lithuanian hyphen-lithuanian collection-langlithuanian
"
TEXLIVE_MODULE_DOC_CONTENTS="lithuanian.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Lithuanian"

LICENSE="GPL-2 LPPL-1.3 "
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2009
"
RDEPEND="${DEPEND} "
