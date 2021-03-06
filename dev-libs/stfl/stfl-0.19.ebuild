# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/stfl/stfl-0.19.ebuild,v 1.7 2010/06/15 16:54:35 arfrever Exp $

EAPI="2"
inherit eutils multilib perl-module python toolchain-funcs

DESCRIPTION="A library which implements a curses-based widget set for text terminals"
HOMEPAGE="http://www.clifford.at/stfl/"
SRC_URI="http://www.clifford.at/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE="examples perl python ruby"

COMMON_DEPEND="sys-libs/ncurses[unicode]
	perl? ( dev-lang/perl )
	ruby? ( dev-lang/ruby )
	python? ( dev-lang/python )"

DEPEND="${COMMON_DEPEND}
		perl? ( dev-lang/swig )
		ruby? ( dev-lang/swig )"

RDEPEND="${COMMON_DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s!-Os -ggdb!!" \
		-e "s!^all:.*!all: libstfl.a!" \
		Makefile

	epatch "${FILESDIR}/${P}-multilib.patch"

	if ! use perl; then
		echo "FOUND_PERL5=0" >>Makefile.cfg
	fi

	if ! use ruby; then
		echo "FOUND_RUBY=0" >>Makefile.cfg
	fi

	if ! use python; then
		echo "FOUND_PYTHON=0" >>Makefile.cfg
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	emake prefix="/usr" DESTDIR="${D}" LIBDIR="$(get_libdir)" install || die "make install failed"

	dodoc README

	local exdir="/usr/share/doc/${PF}/examples"
	if use examples; then
		insinto ${exdir}
		doins example.{c,stfl}
		insinto  ${exdir}/python
		doins python/example.py
		if use perl; then
			insinto ${exdir}/perl
			doins perl5/example.pl
		fi
		if use ruby; then
			insinto ${exdir}/ruby
			doins ruby/example.rb
		fi
	fi

	fixlocalpod
	## Remove some empty directories
	rm -fr "${D}/usr/$(get_libdir)/perl5/5.8.8/" || die "Perl directory cleanup failed"
}

pkg_postinst() {
	python_mod_optimize $(python_get_libdir)/stfl.py
}

pkg_postrm() {
	python_mod_cleanup $(python_get_libdir)/stfl.py
}
