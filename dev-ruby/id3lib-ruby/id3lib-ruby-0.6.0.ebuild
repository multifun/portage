# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/id3lib-ruby/id3lib-ruby-0.6.0.ebuild,v 1.1 2010/05/21 05:50:57 graaff Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES README TODO"

inherit ruby-fakegem

DESCRIPTION="Ruby interface to the id3lib C++ library"
HOMEPAGE="http://id3lib-ruby.rubyforge.org/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="${DEPEND} media-libs/id3lib"
RDEPEND="${RDEPEND} media-libs/id3lib"

each_ruby_configure() {
	pushd ext/id3lib_api
	${RUBY} extconf.rb
	popd
}

each_ruby_compile() {
	pushd ext/id3lib_api
	emake || die "Unable to compile extension."
	popd
}

each_ruby_install() {
	mv ext/id3lib_api/id3lib_api.so lib || die "Unable to install extension."

	each_fakegem_install
}
