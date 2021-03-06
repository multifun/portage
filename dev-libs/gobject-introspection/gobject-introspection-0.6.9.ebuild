# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gobject-introspection/gobject-introspection-0.6.9.ebuild,v 1.1 2010/03/19 14:15:08 nirbheek Exp $

EAPI="2"

inherit python gnome2

DESCRIPTION="Introspection infrastructure for gobject library bindings"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.19.0
	>=dev-lang/python-2.5
	virtual/libffi"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.12 )
	dev-util/pkgconfig
	sys-devel/flex"

src_prepare() {
	G2CONF="${G2CONF} --disable-static"

	# FIXME: Parallel compilation failure with USE=doc
	use doc && MAKEOPTS="-j1"

	# Don't pre-compile .py
	ln -sf $(type -P true) py-compile
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup /usr/lib*/${PN}/giscanner
}
