# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/textpow/textpow-0.10.1.ebuild,v 1.4 2010/05/22 16:03:54 flameeyes Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="A library to parse and process Textmate bundles."
HOMEPAGE="http://textpow.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND=">=dev-ruby/oniguruma-1.1.0
	>=dev-ruby/plist-3.0.0"
RDEPEND="${DEPEND}"
