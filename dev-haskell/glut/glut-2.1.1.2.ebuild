# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/glut/glut-2.1.1.2.ebuild,v 1.1 2009/04/19 11:57:43 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

MY_PN="GLUT"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A binding for the OpenGL Utility Toolkit"
HOMEPAGE="http://www.haskell.org/HOpenGL/"
SRC_URI="http://hackage.haskell.org/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.6.1
		>=dev-haskell/opengl-2.2
		virtual/glu
		virtual/glut"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"

S="${WORKDIR}/${MY_P}"

# TODO: Install examples when the "examples" USE flag is set
