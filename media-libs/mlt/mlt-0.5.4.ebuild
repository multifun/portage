# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mlt/mlt-0.5.4.ebuild,v 1.3 2010/06/17 21:23:24 sping Exp $

EAPI=3
PYTHON_DEPEND="python? 2:2.6"
inherit eutils toolchain-funcs multilib python

DESCRIPTION="An open source multimedia framework, designed and developed for television broadcasting"
HOMEPAGE="http://www.mltframework.org/"
SRC_URI="mirror://sourceforge/mlt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="compressed-lumas dv debug ffmpeg frei0r gtk jack kde libsamplerate melt
mmx qt4 quicktime sdl sse sse2 vorbis xine xml lua python ruby vdpau" # java perl php tcl

RDEPEND="ffmpeg? ( >=media-video/ffmpeg-0.5[vdpau?] )
	dv? ( >=media-libs/libdv-0.104 )
	xml? ( >=dev-libs/libxml2-2.5 )
	vorbis? ( >=media-libs/libvorbis-1.1.2 )
	sdl? ( >=media-libs/libsdl-1.2.10
		 >=media-libs/sdl-image-1.2.4 )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	jack? ( media-sound/jack-audio-connection-kit
		media-libs/ladspa-sdk
		>=dev-libs/libxml2-2.5 )
	frei0r? ( media-plugins/frei0r-plugins )
	gtk? ( x11-libs/gtk+:2
		x11-libs/pango )
	quicktime? ( media-libs/libquicktime )
	xine? ( >=media-libs/xine-lib-1.1.2_pre20060328-r7 )
	qt4? ( x11-libs/qt-gui:4 )
	!media-libs/mlt++
	lua? ( >=dev-lang/lua-5.1.4-r4 )
	ruby? ( dev-lang/ruby )"
#	sox? ( media-sound/sox )
#	java? ( >=virtual/jre-1.5 )
#	perl? ( dev-lang/perl )
#	php? ( dev-lang/php )
#	tcl? ( dev-lang/tcl )

SWIG_DEPEND=">=dev-lang/swig-1.3.38"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	compressed-lumas? ( || ( media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick] ) )
	lua? ( ${SWIG_DEPEND} dev-util/pkgconfig )
	python? ( ${SWIG_DEPEND} )
	ruby? ( ${SWIG_DEPEND} )"
#	java? ( ${SWIG_DEPEND} >=virtual/jdk-1.5 )
#	perl? ( ${SWIG_DEPEND} )
#	php? ( ${SWIG_DEPEND} )
#	tcl? ( ${SWIG_DEPEND} )

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	use vdpau || export MLT_NO_VDPAU=1

	tc-export CC CXX

	local myconf="--enable-gpl
		--enable-motion-est
		$(use_enable debug)
		$(use_enable dv)
		$(use_enable sse)
		$(use_enable sse2)
		$(use_enable gtk gtk2)
		$(use_enable vorbis)
		$(use_enable sdl)
		$(use_enable jack jackrack)
		$(use_enable ffmpeg avformat)
		$(use_enable frei0r)
		$(use_enable melt)
		$(use_enable libsamplerate resample)
		$(use_enable xml)
		$(use_enable xine)
		$(use_enable kde kdenlive)
		$(use_enable qt4 qimage)
		--disable-sox"
		#$(use_enable sox)  FIXME

	use ffmpeg && myconf="${myconf} --avformat-swscale"

	(use quicktime && use dv) ||  myconf="${myconf} --disable-kino"

	use compressed-lumas && myconf="${myconf} --luma-compress"

	( use x86 || use amd64 ) && \
		myconf="${myconf} $(use_enable mmx)" ||
		myconf="${myconf} --disable-mmx"

	use melt || sed -i -e "s;src/melt;;" Makefile

	# TODO: add swig language bindings
	# see also http://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	local swig_lang
	# TODO: java perl php tcl
	for i in lua python ruby ; do
		use $i && swig_lang="${swig_lang} $i"
	done
	[ -z "${swig_lang}" ] && swig_lang="none"

	econf ${myconf} --swig-languages="${swig_lang}"
	sed -i -e s/^OPT/#OPT/ "${S}/config.mak"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README docs/{TODO,*.txt}

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r demo

	docinto swig

	# Install SWIG bindings
	if use lua; then
		cd "${S}"/src/swig/lua
		exeinto $(pkg-config --variable INSTALL_CMOD lua)
		doexe mlt.so || die
		dodoc play.lua
	fi

	if use python; then
		cd "${S}"/src/swig/python
		insinto $(python_get_sitedir)
		doins mlt.py || die
		exeinto $(python_get_sitedir)
		doexe _mlt.so || die
		dodoc play.py
	fi

	if use ruby; then
		cd "${S}"/src/swig/ruby
		exeinto $("${EPREFIX}"/usr/bin/ruby -r rbconfig -e 'print Config::CONFIG["sitearchdir"]')
		doexe mlt.so || die
		dodoc play.rb thumbs.rb
	fi
	# TODO: java perl php tcl
}

pkg_postinst() {
	if use python; then
		python_mod_optimize mlt.py
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup mlt.py
	fi
}
