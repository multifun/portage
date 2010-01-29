# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/aws-s3/aws-s3-0.6.2-r1.ebuild,v 1.2 2010/01/28 14:15:49 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 jruby"

RUBY_FAKEGEM_TASK_DOC="doc:redoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Client library for Amazon's Simple Storage Service's REST API"
HOMEPAGE="http://amazon.rubyforge.org/"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/xml-simple
				dev-ruby/builder
				dev-ruby/mime-types"
ruby_add_bdepend test "virtual/ruby-test-unit dev-ruby/ruby-debug dev-ruby/flexmock"

all_ruby_prepare() {
	# As of release 0.6.2 this part is going to break when building
	# with Ruby 1.9; we disable it since we don't need it at all.
	sed -i -e '/^namespace :site/,/^end/ d' "${S}"/Rakefile \
		|| die "sed out of rake's :site namespace failed"
}
