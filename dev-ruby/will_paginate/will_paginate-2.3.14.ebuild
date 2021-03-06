# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/will_paginate/will_paginate-2.3.14.ebuild,v 1.1 2010/05/27 05:48:34 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Most awesome pagination solution for Ruby  "
HOMEPAGE="http://github.com/mislav/will_paginate/"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/mocha dev-ruby/rack )"
ruby_add_rdepend '>=dev-ruby/activesupport-1.4.4'
