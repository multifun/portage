# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/abinit/abinit-5.4.4-r1.ebuild,v 1.1 2009/12/18 01:26:24 markusle Exp $

inherit fortran toolchain-funcs

DESCRIPTION="Find total energy, charge density and electronic structure using density functional theory"
HOMEPAGE="http://www.abinit.org/"
SRC_URI="ftp://ftp.abinit.org/pub/abinitio/ABINIT_v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpi test"

RDEPEND="virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"

# F90 code, g77 won't work
FORTRAN="gfortran ifc"

pkg_setup() {
	fortran_pkg_setup

	# Doesn't compile with gcc-4.0, only >=4.1
	local diemsg="Requires gcc-4.1 or newer"
	if [[ "${FORTRANC}" = "gfortran" ]]; then
		if [[ $(gcc-major-version) -eq 4 ]] \
			&& [[ $(gcc-minor-version) -lt 1  ]]; then
				die "${diemsg}"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/5.3.4-change-default-directories.patch
	epatch "${FILESDIR}"/5.2.3-fix-64bit-detection.patch
	epatch "${FILESDIR}"/${P}-test.patch

	# bug #223111: Our eautoreconf directory detection breaks
	sed -i -e "s:@abinit_srcdir@/::" Makefile.am

	# bug #223111: libtool 2.2 fix (taken from bug #230271)
	if [ -f '/usr/share/aclocal/ltsugar.m4' ]; then
		cat "/usr/share/aclocal/ltsugar.m4" >> config/m4/libtool.m4
		cat "/usr/share/aclocal/ltversion.m4" >> config/m4/libtool.m4
		cat "/usr/share/aclocal/lt~obsolete.m4" >> config/m4/libtool.m4
		cat "/usr/share/aclocal/ltoptions.m4" >> config/m4/libtool.m4
	fi

	# Yea for breaking compatibility with no ChangeLog entry in 2.60
	if has_version '>=sys-devel/autoconf-2.60'; then
		sed -i -e "s:_AC_SRCPATHS:_AC_SRCDIRS:g" config/m4/init.m4
	fi

	eautoreconf
}

src_compile() {
	econf \
		--disable-config-file \
		$(use_enable mpi) \
		--with-cc-optflags="${CFLAGS}" \
		--with-fc-optflags="${FFLAGS}" \
		--with-fc-ldflags='-lpthread' \
		FC="${FORTRANC}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		|| die "configure failed"

	emake || die "make failed"
}

src_test() {
	einfo "The tests take quite a while, on the order of 2-3 hours"
	einfo "on a dual Athlon 2000+."
	cd "${S}"/tests
	emake tests_dev

	local REPORT
	for REPORT in $(find . -name *fl*); do
		elog "Results for ${REPORT%%/*} tests"
		while read line; do
			elog "${line}"
		done \
			< <(cat ${REPORT} )
	done
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	if use test; then
		dodoc tests/summary_tests.tar.gz
	fi

	dodoc KNOWN_PROBLEMS README
}

pkg_postinst() {
	if use test; then
		elog "The test results will be installed as summary_tests.tar.gz."
	fi
}
