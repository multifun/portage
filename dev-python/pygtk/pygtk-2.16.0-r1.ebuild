# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtk/pygtk-2.16.0-r1.ebuild,v 1.9 2010/05/22 20:13:01 arfrever Exp $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit alternatives autotools eutils flag-o-matic gnome.org python virtualx

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ~ppc64 sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples"

RDEPEND=">=dev-libs/glib-2.8.0
	>=x11-libs/pango-1.16.0
	>=dev-libs/atk-1.12.0
	>=x11-libs/gtk+-2.13.6
	>=gnome-base/libglade-2.5.0
	>=dev-python/pycairo-1.0.2
	>=dev-python/pygobject-2.16.1
	dev-python/numpy"

DEPEND="${RDEPEND}
	doc? (
		dev-libs/libxslt
		>=app-text/docbook-xsl-stylesheets-1.70.1 )
	>=dev-util/pkgconfig-0.9"
RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	# Fix declaration of codegen in .pc
	epatch "${FILESDIR}/${PN}-2.13.0-fix-codegen-location.patch"

	# Fix a crash in gdk.color_from_hsv
	epatch "${FILESDIR}/${P}-gdkcolor-fix.patch"

	# Disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile

	AT_M4DIR="m4" eautoreconf

	python_copy_sources
}

src_configure() {
	use hppa && append-flags -ffunction-sections
	python_src_configure $(use_enable doc docs) --enable-thread
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	testing() {
		if has ${PYTHON_ABI} 2.4 2.5; then
			einfo "Skipping tests with Python ${PYTHON_ABI}. dev-python/pycairo supports only Python >=2.6."
			return 0
		fi

		cd tests
		Xemake check-local
	}
	python_execute_function -s testing
}

src_install() {
	python_src_install
	python_clean_installation_image
	dodoc AUTHORS ChangeLog INSTALL MAPPING NEWS README THREADS TODO

	if use examples; then
		rm examples/Makefile*
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	python_mod_optimize gtk-2.0

	create_symlinks() {
		alternatives_auto_makesym $(python_get_sitedir)/pygtk.py pygtk.py-[0-9].[0-9]
		alternatives_auto_makesym $(python_get_sitedir)/pygtk.pth pygtk.pth-[0-9].[0-9]
	}
	python_execute_function create_symlinks
}

pkg_postrm() {
	python_mod_cleanup gtk-2.0

	create_symlinks() {
		alternatives_auto_makesym $(python_get_sitedir)/pygtk.py pygtk.py-[0-9].[0-9]
		alternatives_auto_makesym $(python_get_sitedir)/pygtk.pth pygtk.pth-[0-9].[0-9]
	}
	python_execute_function create_symlinks
}
