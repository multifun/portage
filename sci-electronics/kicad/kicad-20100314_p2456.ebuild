# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/kicad/kicad-20100314_p2456.ebuild,v 1.1 2010/03/20 03:49:44 calchan Exp $

EAPI="3"
WX_GTK_VER="2.8"

inherit cmake-utils wxwidgets fdo-mime gnome2-utils

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://kicad.sourceforge.net"
SRC_URI="http://dev.gentoo.org/~calchan/distfiles/${PN}-sources-${PV}.tar.xz
	!minimal? ( http://dev.gentoo.org/~calchan/distfiles/${PN}-library-${PV}.tar.xz )
	doc? ( http://dev.gentoo.org/~calchan/distfiles/${PN}-doc-${PV}.tar.xz )
	examples? ( http://dev.gentoo.org/~calchan/distfiles/${PN}-examples-${PV}.tar.xz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dev-doc doc debug examples minimal python"

CDEPEND="x11-libs/wxGTK:2.8[X,opengl]"
DEPEND="${CDEPEND}
	>=dev-util/cmake-2.6.0
	>=dev-libs/boost-1.40
	app-arch/xz-utils
	dev-doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	sys-libs/zlib
	sci-electronics/electronics-menu
	python? ( dev-lang/python )"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Use native boost
	sed -i -e '/Boost/s/^#check_find_package/check_find_package/' \
		-e '/Boost/s/^#find_package/find_package/' CMakeLists.txt || die "sed failed"

	# Add important doc files
	sed -i -e 's/INSTALL.txt/AUTHORS.txt CHANGELOG.txt README.txt TODO.txt/' CMakeLists.txt || die "sed failed"

	# Fix desktop files
	rm resources/linux/mime/applications/eeschema.desktop
	sed -i -e 's/Development;//' resources/linux/mime/applications/kicad.desktop || die "sed failed"

	# Handle optional minimal install
	if use minimal ; then
		sed -i -e '/add_subdirectory(template)/d' CMakeLists.txt || die "sed failed"
	else
		sed -i -e '/add_subdirectory(template)/a \
add_subdirectory(kicad-library)' CMakeLists.txt || die "sed failed"
	fi

	# Add documentation and fix necessary code if requested
	if use doc ; then
		sed -i -e '/add_subdirectory(demos)/a \
add_subdirectory(kicad-doc)' CMakeLists.txt || die "sed failed"
		sed -i -e "s/subdirs.Add( wxT( \"kicad\" ) );/subdirs.Add( wxT( \"${PF}\" ) );/" \
			-e '/subdirs.Add( _T( "help" ) );/d' common/edaappl.cpp || die "sed failed"
	fi

	# Install examples in the right place if requested
	if use examples ; then
		sed -i -e 's:${KICAD_DATA}/demos:${KICAD_DOCS}/examples:' CMakeLists.txt || die "sed failed"
	else
		sed -i -e '/add_subdirectory(demos)/d' CMakeLists.txt || die "sed failed"
	fi
}

src_configure() {
	need-wxwidgets unicode

	mycmakeargs="${mycmakeargs}
		-DKICAD_MINIZIP=OFF
		-DKICAD_CYRILLIC=ON
		-DwxUSE_UNICODE=ON
		-DKICAD_GOST=OFF
		-DKICAD_AUIMANAGER=OFF
		-DKICAD_AUITOOLBAR=OFF
		-DKICAD_DOCS=/usr/share/doc/${PF}
		-DKICAD_HELP=/usr/share/doc/${PF}
		$(cmake-utils_use python KICAD_PYTHON)"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use dev-doc && doxygen Doxyfile
}

src_install() {
	cmake-utils_src_install
	if use dev-doc ; then
		insinto /usr/share/doc/${PF}
		doins uncrustify.cfg
		cd Documentation
		doins -r GUI_Translation_HOWTO.pdf guidelines/UIpolicies.txt doxygen/doxygen
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	if use minimal ; then
		ewarn "If the schematic and/or board editors complain about missing libraries when you"
		ewarn "open old projects, you will have to take one or more of the following actions :"
		ewarn "- Install the missing libraries manually."
		ewarn "- Remove the libraries from the 'Libs and Dir' preferences."
		ewarn "- Fix the libraries' locations in the 'Libs and Dir' preferences."
		ewarn "- Emerge kicad without the 'minimal' USE flag."
		elog
	fi
	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
