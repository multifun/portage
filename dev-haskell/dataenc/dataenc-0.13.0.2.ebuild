# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/dataenc/dataenc-0.13.0.2.ebuild,v 1.2 2010/04/01 09:44:23 grobian Exp $

CABAL_FEATURES="bin lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Data encoding library"
HOMEPAGE="http://www.haskell.org/haskellwiki/Library/Data_encoding"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~ppc-macos"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6.1
		>=dev-haskell/cabal-1.2"
