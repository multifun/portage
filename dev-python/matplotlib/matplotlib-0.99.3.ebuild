# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/matplotlib/matplotlib-0.99.3.ebuild,v 1.2 2010/06/07 16:44:27 bicatali Exp $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
WX_GTK_VER="2.8"

inherit eutils distutils wxwidgets flag-o-matic

PDOC="users_guide_${PV}"

DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="http://matplotlib.sourceforge.net/ http://pypi.python.org/pypi/matplotlib"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

IUSE="cairo doc excel examples fltk gtk latex qt4 traits tk wxwidgets"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
LICENSE="PYTHON BSD"

CDEPEND="dev-python/numpy
	dev-python/python-dateutil
	dev-python/pytz
	media-libs/freetype:2
	media-libs/libpng
	gtk? ( dev-python/pygtk )
	tk? ( dev-lang/python[tk] )
	wxwidgets? ( dev-python/wxpython:2.8 )"

DEPEND="${CDEPEND}
	dev-python/pycxx
	dev-util/pkgconfig
	doc? (
		dev-python/sphinx
		media-gfx/graphviz[cairo]
		|| ( ( dev-texlive/texlive-latexextra
			   dev-texlive/texlive-fontsrecommended
			   dev-texlive/texlive-latexrecommended )
			 ( app-text/ptex dev-tex/latex-unicode ) )
		app-text/dvipng
		dev-python/imaging
		dev-python/ipython
		excel?  ( dev-python/xlwt ) )"

RDEPEND="${CDEPEND}
	virtual/ttf-fonts
	media-fonts/texcm-ttf
	dev-python/pyparsing
	cairo?  ( dev-python/pycairo )
	excel?  ( dev-python/xlwt )
	fltk?   ( dev-python/pyfltk )
	qt4?    ( dev-python/PyQt4[X] )
	traits? ( dev-python/traits dev-python/configobj )
	latex?  (
		virtual/latex-base
		app-text/ghostscript-gpl
		app-text/dvipng
		app-text/poppler[utils]
		|| ( dev-texlive/texlive-fontsrecommended
			 app-text/ptex ) )"
RESTRICT_PYTHON_ABIS="3.*"

DOCS="INTERACTIVE"

use_setup() {
	local uword="${2}"
	[ -z "${2}" ] && uword="${1}"
	if use ${1}; then
		echo "${uword} = True"
		echo "${uword}agg = True"
	else
		echo "${uword} = False"
		echo "${uword}agg = False"
	fi
}

src_prepare() {
	# avoid to launch xv while building examples docs
	epatch "${FILESDIR}"/${PN}-0.98.5.2-no-xv.patch
	# allow better small docs (from upstream svn)
	epatch "${FILESDIR}"/${PN}-0.99.1.1-docs.patch
	# allow compatibility with pygtk-2.12 tooltop (from upstream svn)
	epatch "${FILESDIR}"/${PN}-0.99.1.1-gtk-tooltip.patch
	# some font stuff (from upstream svn)
	epatch "${FILESDIR}"/${PN}-0.99.1.1-eintr.patch
	# avoid slow piwik (bug #323005)
	epatch "${FILESDIR}"/${PN}-0.99.3-nopiwik.patch

	# create setup.cfg (see setup.cfg.template for any changes)
	cat > setup.cfg <<-EOF
		[provide_packages]
		pytz = False
		dateutil = False
		configobj = False
		enthought.traits = False
		[gui_support]
		$(use_setup gtk)
		$(use_setup tk)
		$(use_setup wxwidgets wx)
		$(use_setup qt4)
		$(use_setup fltk)
		$(use_setup cairo)
	EOF

	# avoid checks needing a X display
	sed -i \
		-e "s/check_for_gtk()/$(use gtk && echo True || echo False)/" \
		-e "s/check_for_tk()/$(use tk && echo True || echo False)/" \
		setup.py || die "sed setup.py failed"

	# respect FHS:
	#  - mpl-data in /usr/share/matplotlib
	#  - config files in /etc/matplotlib
	sed -i \
		-e "/'mpl-data\/matplotlibrc',/d" \
		-e "/'mpl-data\/matplotlib.conf',/d" \
		-e "s:'lib/matplotlib/mpl-data/matplotlibrc':'matplotlibrc':" \
		-e "s:'lib/matplotlib/mpl-data/matplotlib.conf':'matplotlib.conf':" \
		setup.py \
		|| die "sed setup.py for FHS failed"

	# remove internal copies of fonts, pycxx, pyparsing
	rm -rf \
		CXX \
		lib/matplotlib/mpl-data/fonts/{afm,pdfcorefonts} \
		lib/matplotlib/mpl-data/fonts/ttf/{Vera*,cm*,*.TXT} \
		lib/matplotlib/pyparsing.py \
		|| die "removed internal copies failed"

	sed -i \
		-e 's/matplotlib.pyparsing/pyparsing/g' \
		lib/matplotlib/{mathtext,fontconfig_pattern}.py \
		|| die "sed pyparsing failed"
}

src_compile() {
	unset DISPLAY # bug #278524
	append-flags -DNDEBUG # bug #322347
	distutils_src_compile_pre_hook() {
		ln -fs "${EPREFIX}/usr/share/python$(python_get_version)/CXX" .
	}
	distutils_src_compile

	if use doc; then
		cd "${S}/doc"
		export VARTEXFONTS="${T}"/fonts
		MATPLOTLIBDATA="${S}/lib/matplotlib/mpl-data" \
			PYTHONPATH=$(ls -d "${S}"/build-$(PYTHON -f --ABI)/lib*) \
			"$(PYTHON -f)" make.py --small all
		[[ -e build/latex/Matplotlib.pdf ]] || die "doc generation failed"
	fi
}

src_test() {
	# if doc were enabled, all examples were built and tested
	use doc && return
	einfo "Tests are quite long, be patient"
	cd "${S}/examples/tests"
	testing() {
		PYTHONPATH=$(ls -d "${S}"/build-${PYTHON_ABI}/lib*) "$(PYTHON)" backend_driver.py agg || return 1
		PYTHONPATH=$(ls -d "${S}"/build-${PYTHON_ABI}/lib*) "$(PYTHON)" backend_driver.py --clean
	}
	python_execute_function testing
}

src_install() {
	# sed only after doc building, to allow using default configs
	sed -i \
		-e "s:path =  get_data_path():path = '${EPREFIX}/etc/matplotlib':" \
		-e "s:os.path.dirname(__file__):'${EPREFIX}/usr/share/${PN}':g"  \
		build-*/lib*/matplotlib/__init__.py \
		|| die "sed init for FHS failed"
	[[ -z ${ED} ]] && local ED="${D}"
	distutils_src_install

	# Respect FHS
	dodir /usr/share/${PN}
	mv "${ED}$(python_get_sitedir -f)/${PN}/"{mpl-data,backends/Matplotlib.nib} "${ED}usr/share/${PN}" || die "Renaming failed"
	rm -fr "${ED}"usr/lib*/python*/site-packages/${PN}/{mpl-data,backends/Matplotlib.nib}

	insinto /etc/matplotlib
	doins matplotlibrc matplotlib.conf || die "installing config files failed"

	# doc and examples
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins doc/build/latex/Matplotlib.pdf || die
		doins -r doc/build/html || die
	fi
	if use examples; then
		doins -r examples || die
	fi
}
