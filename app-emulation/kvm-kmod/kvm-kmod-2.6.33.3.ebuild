# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/kvm-kmod/kvm-kmod-2.6.33.3.ebuild,v 1.1 2010/04/29 01:59:15 cardoe Exp $

EAPI="2"

inherit eutils linux-mod

SRC_URI="mirror://sourceforge/kvm/${P}.tar.bz2"

DESCRIPTION="Kernel-based Virtual Machine kernel modules"
HOMEPAGE="http://www.linux-kvm.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_chkconfig_present KVM; then
		eerror "KVM now needs CONFIG_KVM built into your kernel, even"
		eerror "if you're using the external modules from this package."
		eerror "Please enable KVM support in your kernel, found at:"
		eerror
		eerror "  Virtualization"
		eerror "    Kernel-based Virtual Machine (KVM) support"
		eerror
		die "KVM support not detected!"
	fi
	BUILD_TARGETS="all"
	MODULE_NAMES="kvm(kernel/arch/x86/kvm/:${S}:${S}/x86)"
	MODULE_NAMES="${MODULE_NAMES} kvm-intel(kernel/arch/x86/kvm/:${S}:${S}/x86)"
	MODULE_NAMES="${MODULE_NAMES} kvm-amd(kernel/arch/x86/kvm/:${S}:${S}/x86)"
	linux-mod_pkg_setup
}

src_configure() {
	local conf_opts

	conf_opts="--kerneldir=$KV_DIR"

	if has_multilib_profile && [[ "${DEFAULT_ABI}" == "x86" ]] ; then
		conf_opts="$conf_opts --arch=x86"
	fi

	./configure ${conf_opts} || die "configure failed"
}

src_compile() {
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}

pkg_preinst() {
	find /lib/modules/${KV_FULL} -name 'kvm*.ko' -type f -delete

	linux-mod_pkg_preinst
}
