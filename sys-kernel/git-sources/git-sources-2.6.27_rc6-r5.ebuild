# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/git-sources/git-sources-2.6.27_rc6-r5.ebuild,v 1.2 2008/09/25 01:01:30 mpagano Exp $

UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
ETYPE="sources"
CKV="${PVR/-r/-git}"
# only use this if it's not an _rc/_pre release
[ "${PV/_pre}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit kernel-2
detect_version

DESCRIPTION="The very latest -git version of the Linux kernel"
HOMEPAGE="http://www.kernel.org"
#SRC_URI="${KERNEL_URI} mirror://kernel/linux/kernel/v2.6/snapshots/patch-${KV_FULL}.bz2"
SRC_URI="${KERNEL_URI}"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its unstable and
experimental nature. If you have any issues, try a matching vanilla-sources
ebuild -- if the problem is not there, please contact the upstream kernel
developers at http://bugme.osdl.org and on the linux-kernel mailing list to
report the problem so it can be fixed in time for the next kernel release."

K_EXTRAEWARN="If your system utilizes the e1000e driver DO NOT install and run
any 2.6.27 kernel.  See bug #238489 for more information"

pkg_postinst() {
	postinst_sources
}