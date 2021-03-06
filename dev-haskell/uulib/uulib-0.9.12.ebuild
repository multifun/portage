# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/uulib/uulib-0.9.12.ebuild,v 1.1 2010/06/14 17:43:01 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Haskell Utrecht Tools Library"
HOMEPAGE="http://www.cs.uu.nl/wiki/HUT/WebHome"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.8.1"
DEPEND=">=dev-haskell/cabal-1.1
		${RDEPEND}"
