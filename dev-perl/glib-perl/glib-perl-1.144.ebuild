# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/glib-perl/glib-perl-1.144.ebuild,v 1.10 2009/04/06 14:40:02 armin76 Exp $

inherit perl-module eutils

MY_P=Glib-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Glib - Perl wrappers for the GLib utility and Object libraries"
HOMEPAGE="http://gtk2-perl.sf.net/"
SRC_URI="mirror://cpan/authors/id/T/TS/TSCH/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE="xml"
SRC_TEST="do"

RDEPEND=">=dev-libs/glib-2
	dev-lang/perl
	xml? ( dev-perl/XML-Writer
		dev-perl/XML-Parser )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-perl/extutils-depends-0.205
	>=dev-perl/extutils-pkgconfig-1.07"
