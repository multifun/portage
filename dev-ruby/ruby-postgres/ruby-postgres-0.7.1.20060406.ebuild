# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-postgres/ruby-postgres-0.7.1.20060406.ebuild,v 1.7 2010/06/17 18:33:44 patrick Exp $

inherit ruby gems versionator

# changes 0.7.1.20060406 to 0.7.1.2006.04.06

# ideally, PV would have been this to start with, but can't change it now as
# 0.7.1.20051221 > 0.7.1.2006.04.06.
MY_PV="0.7.1.2006.04.06"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="An extension library to access a PostgreSQL database from Ruby"
HOMEPAGE="http://ruby.scripting.ca/postgres"
SRC_URI="mirror://rubygems/${MY_P}.gem"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
USE_RUBY="ruby18"

RDEPEND="dev-db/postgresql-base"
DEPEND="${RDEPEND}
	>=dev-ruby/rubygems-0.9.0-r1"
