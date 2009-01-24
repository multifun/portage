# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2

inherit eutils java-pkg-2 versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-3 ${PV})
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - solvers"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz -> ${MY_P}.General.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-bin-${MY_PV}*
	<virtual/jdk-1.5
	=sci-libs/openfoam-kernel-${MY_PV}*"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.1"

S=${WORKDIR}/${MY_P}
INSDIR="/usr/$(get_libdir)/${MY_PN}/${MY_P}"

pkg_setup() {
	# just to be sure the right profile is selected (gcc-config)
	if ! version_is_at_least 4.1 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi

	java-pkg-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/${PN}-compile-${PV}.patch
}

src_compile() {
	cp -a ${INSDIR}/.bashrc "${S}"/.bashrc || "cannot copy .bashrc"
	cp -a ${INSDIR}/.${MY_P}/bashrc "${S}"/.${MY_P}/bashrc.bak || "cannot copy bashrc"

	use amd64 && export WM_64="on"

	sed -i -e "s|WM_PROJECT_INST_DIR=/usr/$(get_libdir)/\$WM_PROJECT|WM_PROJECT_INST_DIR="${WORKDIR}"|"	\
		-e "s|WM_PROJECT_DIR=\$WM_PROJECT_INST_DIR/\$WM_PROJECT-\$WM_PROJECT_VERSION|WM_PROJECT_DIR="${S}"|"	\
		"${S}"/.${MY_P}/bashrc.bak || die "could not replace source options"

	sed -i -e "s|\$WM_PROJECT_INST_DIR/\$WM_ARCH/bin|"${INSDIR}"/bin|"	\
		-e "s|FOAM_LIB=\$WM_PROJECT_DIR/lib|FOAM_LIB="${INSDIR}"/lib|"	\
		-e "s|FOAM_LIBBIN=\$FOAM_LIB|FOAM_LIBBIN=\$WM_PROJECT_DIR/lib/\$WM_OPTIONS|"	\
		-e "s|AddLib \$FOAM_USER_LIBBIN|AddLib \$FOAM_LIB|"	\
		-e "s|applications/bin|applications/bin/\$WM_OPTIONS|"	\
		-e "s|FOAM_MPI_LIBBIN=\$FOAM_LIBBIN/|FOAM_MPI_LIBBIN="${INSDIR}"/lib/|"	\
		"${S}"/.bashrc || die "could not replace paths"

	sed -i -e "s|-L\$(LIB_WM_OPTIONS_DIR)|-L\$(LIB_WM_OPTIONS_DIR) -L${INSDIR}/lib|" \
		"${S}"/wmake/Makefile || die "could not replace search paths"

	source "${S}"/.${MY_P}/bashrc.bak

	cd "${S}"/applications/solvers
	wmake all || die "could not build OpenFOAM utilities"
}

src_install() {
	insopts -m0755
	insinto ${INSDIR}/applications/bin
	doins -r applications/bin/${WM_OPTIONS}/* || die "doins failed"

	insinto ${INSDIR}/lib
	doins -r lib/${WM_OPTIONS}/* || die "doins failed"

	find "${S}"/applications -type d \( -name "${WM_OPTIONS}" -o -name linuxDebug -o -name linuxOpt \)  | xargs rm -rf

	insopts -m0644
	insinto ${INSDIR}/applications
	doins -r applications/solvers || die "doins failed"
}