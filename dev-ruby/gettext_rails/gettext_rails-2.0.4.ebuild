# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/gettext_rails/gettext_rails-2.0.4.ebuild,v 1.4 2010/01/10 18:41:07 nixnut Exp $

inherit gems

DESCRIPTION="An L10 library for Ruby on Rails."
HOMEPAGE="http://www.yotabanana.com/hiki/ruby-gettext-rails.html"
LICENSE="Ruby"

KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE=""

USE_RUBY="ruby18"

RDEPEND="
	>=dev-ruby/gettext_activerecord-2.0.4
	>=dev-ruby/locale_rails-2.0.4
	>=dev-ruby/rails-2.3.2"
DEPEND="${RDEPEND}"
