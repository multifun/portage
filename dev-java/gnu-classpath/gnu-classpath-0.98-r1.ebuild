# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-classpath/gnu-classpath-0.98-r1.ebuild,v 1.9 2010/03/25 13:15:47 caster Exp $

EAPI=2

inherit eutils java-pkg-2 base multilib

MY_P=${P/gnu-/}
DESCRIPTION="Free core class libraries for use with virtual machines and compilers for the Java language"
SRC_URI="mirror://gnu/classpath/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/classpath"

LICENSE="GPL-2-with-linking-exception"
SLOT="0.98"
KEYWORDS="amd64 ppc ppc64 x86"

IUSE="alsa debug doc dssi examples gconf gjdoc gmp gtk gstreamer qt4 xml"

RDEPEND="alsa? ( media-libs/alsa-lib )
		doc? ( >=dev-java/gjdoc-0.7.9-r2 )
		dssi? ( >=media-libs/dssi-0.9 )
		gconf? ( gnome-base/gconf )
		gjdoc? ( >=dev-java/antlr-2.7.1:0 )
		gmp? ( >=dev-libs/gmp-4.2.4 )
		gstreamer? (
			>=media-libs/gstreamer-0.10.10
			>=media-libs/gst-plugins-base-0.10.10
			x11-libs/gtk+
		)
		gtk? (
				>=x11-libs/gtk+-2.8
				>=dev-libs/glib-2.0
				media-libs/freetype
				>=x11-libs/cairo-1.1.9
				x11-libs/libICE
				x11-libs/libSM
				x11-libs/libX11
				x11-libs/libXrandr
				x11-libs/libXrender
				x11-libs/libXtst
				x11-libs/pango
		)
		qt4? ( x11-libs/qt-gui:4 )
		xml? ( >=dev-libs/libxml2-2.6.8 >=dev-libs/libxslt-1.1.11 )
		dev-java/eclipse-ecj:3.3"

# We should make the build not pickup the wrong antlr binary from pccts
DEPEND="app-arch/zip
		gjdoc? ( !!dev-util/pccts )
		gtk? (
			x11-libs/libXrender
			|| ( >=x11-libs/libXtst-1.1.0 <x11-proto/xextproto-7.1 )
			x11-proto/xproto
		)
		>=virtual/jdk-1.5
		${RDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	# We require ecj anyway, so force it to avoid problems with bad versions of javac
	export JAVAC="/usr/bin/ecj-3.3"
	export JAVA="/usr/bin/java"
	# build takes care of them itself, duplicate -source -target kills ecj
	export JAVACFLAGS="-nowarn"
	# build system is passing -J-Xmx768M which ecj however ignores
	# this will make the ecj launcher do it (seen case where default was not enough heap)
	export gjl_java_args="-Xmx768M"

	# don't use econf, because it ends up putting things under /usr, which may
	# collide with other slots of classpath
	local myconf
	if use gjdoc; then
		local antlr=$(java-pkg_getjar antlr antlr.jar)
		myconf="--with-antlr-jar=${antlr}"
	fi

	ANTLR= ./configure \
		$(use_enable alsa) \
		$(use_enable debug ) \
		$(use_enable examples) \
		$(use_enable gconf gconf-peer) \
		$(use_enable gjdoc) \
		$(use_enable gmp) \
		$(use_enable gtk gtk-peer) \
		$(use_enable gstreamer gstreamer-peer) \
		$(use_enable qt4 qt-peer) \
		$(use_enable xml xmlj) \
		$(use_enable dssi ) \
		$(use_with doc gjdoc) \
		--enable-jni \
		--disable-dependency-tracking \
		--disable-plugin \
		--host=${CHOST} \
		--prefix=/usr/${PN}-${SLOT} \
		--with-ecj-jar=$(java-pkg_getjar eclipse-ecj:3.3 ecj.jar) \
		--disable-Werror \
		${myconf} \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog* HACKING NEWS README THANKYOU TODO || die
	java-pkg_regjar /usr/${P}/share/classpath/glibj.zip
}
