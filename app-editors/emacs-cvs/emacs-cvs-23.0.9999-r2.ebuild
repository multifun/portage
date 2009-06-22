# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs-cvs/emacs-cvs-23.0.9999-r2.ebuild,v 1.1 2009/06/21 17:00:33 ulm Exp $

EAPI=2

inherit autotools elisp-common eutils flag-o-matic

if [ "${PV##*.}" = "9999" ]; then
	ECVS_AUTH="pserver"
	ECVS_SERVER="cvs.savannah.gnu.org:/sources/emacs"
	ECVS_MODULE="emacs"
	ECVS_BRANCH="EMACS_23_1_RC"
	ECVS_LOCALNAME="emacs-23.1"
	inherit cvs
	SRC_URI=""
	S="${WORKDIR}/${ECVS_LOCALNAME}"
else
	SRC_URI="mirror://gentoo/emacs-${PV}.tar.gz
		ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-${PV}.tar.gz"
	# FULL_VERSION keeps the full version number, which is needed in
	# order to determine some path information correctly for copy/move
	# operations later on
	FULL_VERSION="${PV%%_*}"
	S="${WORKDIR}/emacs-${FULL_VERSION}"
fi

DESCRIPTION="The extensible, customizable, self-documenting real-time display editor"
HOMEPAGE="http://www.gnu.org/software/emacs/"

LICENSE="GPL-3 FDL-1.3 BSD as-is X11 W3C unicode"
SLOT="23"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="alsa dbus gif gpm gtk gzip-el hesiod jpeg kerberos m17n-lib motif png sound source svg tiff toolkit-scroll-bars X Xaw3d xft +xpm"
RESTRICT="strip"

RDEPEND="sys-libs/ncurses
	>=app-admin/eselect-emacs-1.2
	net-libs/liblockfile
	hesiod? ( net-dns/hesiod )
	kerberos? ( virtual/krb5 )
	alsa? ( media-libs/alsa-lib )
	gpm? ( sys-libs/gpm )
	dbus? ( sys-apps/dbus )
	X? (
		x11-libs/libXmu
		x11-libs/libXt
		x11-misc/xbitmaps
		gif? ( media-libs/giflib )
		jpeg? ( media-libs/jpeg )
		png? ( media-libs/libpng )
		svg? ( >=gnome-base/librsvg-2.0 )
		tiff? ( media-libs/tiff )
		xpm? ( x11-libs/libXpm )
		xft? (
			media-libs/fontconfig
			media-libs/freetype
			x11-libs/libXft
			m17n-lib? (
				>=dev-libs/libotf-0.9.4
				>=dev-libs/m17n-lib-1.5.1
			)
		)
		gtk? ( x11-libs/gtk+:2 )
		!gtk? (
			Xaw3d? ( x11-libs/Xaw3d )
			!Xaw3d? ( motif? ( x11-libs/openmotif ) )
		)
	)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	gzip-el? ( app-arch/gzip )"

RDEPEND="${RDEPEND}
	>=app-emacs/emacs-common-gentoo-1[X?]"

EMACS_SUFFIX="emacs-${SLOT}"
SITEFILE="20${PN}-${SLOT}-gentoo.el"

src_prepare() {
	if [ "${PV##*.}" = "9999" ]; then
		FULL_VERSION=$(grep 'defconst[	 ]*emacs-version' lisp/version.el \
			| sed -e 's/^[^"]*"\([^"]*\)".*$/\1/')
		[ "${FULL_VERSION}" ] || die "Cannot determine current Emacs version"
		echo
		einfo "Emacs CVS branch: ${ECVS_BRANCH}"
		einfo "Emacs version number: ${FULL_VERSION}"
		[ "${FULL_VERSION%.*}" = ${PV%.*} ] \
			|| die "Upstream version number changed to ${FULL_VERSION}"
		echo
	fi

	sed -i -e "s:/usr/lib/crtbegin.o:$(`tc-getCC` -print-file-name=crtbegin.o):g" \
		-e "s:/usr/lib/crtend.o:$(`tc-getCC` -print-file-name=crtend.o):g" \
		"${S}"/src/s/freebsd.h || die "unable to sed freebsd.h settings"

	if ! use alsa; then
		# ALSA is detected even if not requested by its USE flag.
		# Suppress it by supplying pkg-config with a wrong library name.
		sed -i -e "/ALSA_MODULES=/s/alsa/DiSaBlEaLsA/" configure.in \
			|| die "unable to sed configure.in"
	fi
	if ! use gzip-el; then
		# Emacs' build system automatically detects the gzip binary and
		# compresses el files. We don't want that so confuse it with a
		# wrong binary name
		sed -i -e "s/ gzip/ PrEvEnTcOmPrEsSiOn/" configure.in \
			|| die "unable to sed configure.in"
	fi

	eautoreconf
}

src_configure() {
	ALLOWED_FLAGS=""
	strip-flags
	#unset LDFLAGS
	if use sh; then
		replace-flags -O[1-9] -O0		#262359
	else
		replace-flags -O[3-9] -O2
	fi

	local myconf

	if use alsa && ! use sound; then
		echo
		einfo "Although sound USE flag is disabled you chose to have alsa,"
		einfo "so sound is switched on anyway."
		echo
		myconf="${myconf} --with-sound"
	else
		myconf="${myconf} $(use_with sound)"
	fi

	if use X; then
		myconf="${myconf} --with-x"
		myconf="${myconf} $(use_with toolkit-scroll-bars)"
		myconf="${myconf} $(use_with gif) $(use_with jpeg)"
		myconf="${myconf} $(use_with png) $(use_with svg rsvg)"
		myconf="${myconf} $(use_with tiff) $(use_with xpm)"
		myconf="${myconf} $(use_with xft)"

		if use xft; then
			myconf="${myconf} $(use_with m17n-lib libotf)"
			myconf="${myconf} $(use_with m17n-lib m17n-flt)"
		else
			myconf="${myconf} --without-libotf --without-m17n-flt"
			use m17n-lib && ewarn \
				"USE flag \"m17n-lib\" has no effect because xft is not set."
		fi

		# GTK+ is the default toolkit if USE=gtk is chosen with other
		# possibilities. Emacs upstream thinks this should be standard
		# policy on all distributions
		if use gtk; then
			einfo "Configuring to build with GIMP Toolkit (GTK+)"
			myconf="${myconf} --with-x-toolkit=gtk"
		elif use Xaw3d; then
			einfo "Configuring to build with Xaw3d (Athena/Lucid) toolkit"
			myconf="${myconf} --with-x-toolkit=athena"
		elif use motif; then
			einfo "Configuring to build with Motif toolkit"
			myconf="${myconf} --with-x-toolkit=motif"
		else
			einfo "Configuring to build with no toolkit"
			myconf="${myconf} --with-x-toolkit=no"
		fi

		local f tk=
		for f in gtk Xaw3d motif; do
			use ${f} || continue
			[ "${tk}" ] \
				&& ewarn "USE flag \"${f}\" ignored (superseded by \"${tk}\")"
			tk="${tk}${tk:+ }${f}"
		done
	else
		myconf="${myconf} --without-x"
	fi

	myconf="${myconf} $(use_with hesiod)"
	myconf="${myconf} $(use_with kerberos) $(use_with kerberos kerberos5)"
	myconf="${myconf} $(use_with gpm) $(use_with dbus)"

	econf \
		--program-suffix=-${EMACS_SUFFIX} \
		--infodir=/usr/share/info/${EMACS_SUFFIX} \
		${myconf} || die "econf emacs failed"
}

src_compile() {
	export SANDBOX_ON=0			# for the unbelievers, see Bug #131505
	if [ "${PV##*.}" = "9999" ]; then
		emake CC="$(tc-getCC)" bootstrap || die "make bootstrap failed"
		# cleanup, otherwise emacs will be dumped again in src_install
		(cd src; emake versionclean)
	fi
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install () {
	local i m

	emake install DESTDIR="${D}" || die "make install failed"

	rm "${D}"/usr/bin/emacs-${FULL_VERSION}-${EMACS_SUFFIX} \
		|| die "removing duplicate emacs executable failed"
	mv "${D}"/usr/bin/emacs-${EMACS_SUFFIX} "${D}"/usr/bin/${EMACS_SUFFIX} \
		|| die "moving Emacs executable failed"

	# move info documentation to the correct place
	for i in "${D}"/usr/share/info/${EMACS_SUFFIX}/*; do
		mv "${i}" "${i}.info" || die "mv info failed"
	done

	# move man pages to the correct place
	for m in "${D}"/usr/share/man/man1/* ; do
		mv "${m}" "${m%.1}-${EMACS_SUFFIX}.1" || die "mv man failed"
	done

	# avoid collision between slots, see bug #169033 e.g.
	rm "${D}"/usr/share/emacs/site-lisp/subdirs.el
	rm -rf "${D}"/usr/share/{applications,icons}
	rm "${D}"/var/lib/games/emacs/{snake,tetris}-scores
	keepdir /var/lib/games/emacs

	local c=";;"
	if use source; then
		insinto /usr/share/emacs/${FULL_VERSION}/src
		# This is not meant to install all the source -- just the
		# C source you might find via find-function
		doins src/*.[ch]
		c=""
	fi

	sed 's/^X//' >"${SITEFILE}" <<-EOF
	X
	;;; ${PN}-${SLOT} site-lisp configuration
	X
	(when (string-match "\\\\\`${FULL_VERSION//./\\\\.}\\\\>" emacs-version)
	X  ${c}(setq find-function-C-source-directory
	X  ${c}      "/usr/share/emacs/${FULL_VERSION}/src")
	X  (let ((path (getenv "INFOPATH"))
	X	(dir "/usr/share/info/${EMACS_SUFFIX}"))
	X    (and path
	X	 ;; move Emacs Info dir to beginning of list
	X	 (setq Info-directory-list
	X	       (cons dir (delete dir (split-string path ":" t)))))))
	EOF
	elisp-site-file-install "${SITEFILE}" || die

	dodoc README BUGS || die "dodoc failed"
}

emacs-infodir-rebuild() {
	# Depending on the Portage version, the Info dir file is compressed
	# or removed. It is only rebuilt by Portage if our directory is in
	# INFOPATH, which is not guaranteed. So we rebuild it ourselves.

	local infodir=/usr/share/info/${EMACS_SUFFIX} f
	[ -d "${ROOT}"${infodir} ] || return	# may occur with FEATURES=noinfo
	einfo "Regenerating Info directory index in ${infodir} ..."
	rm -f "${ROOT}"${infodir}/dir{,.*}
	for f in "${ROOT}"${infodir}/*.info*; do
		[[ ${f##*/} != *[0-9].info* && -e ${f} ]] \
			&& install-info --info-dir="${ROOT}"${infodir} "${f}" &>/dev/null
	done
	rmdir "${ROOT}"${infodir} 2>/dev/null	# remove dir if it is empty
	echo
}

pkg_postinst() {
	local f
	for f in "${ROOT}"/var/lib/games/emacs/{snake,tetris}-scores; do
		[ -e "${f}" ] || touch "${f}"
	done

	elisp-site-regen
	emacs-infodir-rebuild
	eselect emacs update ifunset

	echo
	elog "You can set the version to be started by /usr/bin/emacs through"
	elog "the Emacs eselect module, which also redirects man and info pages."
	elog "You can therefore test emacs-cvs along with the stable release."
	elog "\"man emacs.eselect\" for details."
}

pkg_postrm() {
	elisp-site-regen
	emacs-infodir-rebuild
	eselect emacs update ifunset
}
