# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubyforge/rubyforge-2.0.4-r1.ebuild,v 1.3 2010/05/22 22:56:01 a3li Exp $

EAPI=2

USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Simplistic script which automates a limited set of rubyforge operations"
HOMEPAGE="http://codeforpeople.rubyforge.org/rubyforge/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_rdepend '>=dev-ruby/json-1.1.7'

ruby_add_bdepend "
	doc? ( dev-ruby/hoe )
	test? (
		virtual/ruby-test-unit
		dev-ruby/hoe
	)"

# JRuby-specific dependency
USE_RUBY="jruby" ruby_add_bdepend "test? ( dev-ruby/jruby-openssl )"
