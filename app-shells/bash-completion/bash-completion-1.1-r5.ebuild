# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bash-completion/bash-completion-1.1-r5.ebuild,v 1.9 2010/05/13 20:22:11 grobian Exp $

EAPI="2"
inherit prefix

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="http://bash-completion.alioth.debian.org/"
SRC_URI="http://bash-completion.alioth.debian.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect
	|| ( app-shells/bash app-shells/zsh )
	sys-apps/miscfiles"
PDEPEND="app-shells/gentoo-bashcomp"

src_prepare() {
	cp "${FILESDIR}/bash-completion.sh" "${T}" || die
	eprefixify "${T}/bash-completion.sh"
	# On the roadmap to change in next release, "2.0"
	sed -i -e 's/declare -r bash4/export bash4/' bash_completion || die
	# Fix rsync ssh remote path completion bug 297818, committed upstream.
	sed -i -e 's/cur=`_get_cword`/cur=`_get_cword ":"`/' contrib/rsync || die
}

src_install() {
	use prefix || local ED=${D}
	emake DESTDIR="${D}" install || die

	dodir /etc/profile.d
	cp "${T}/bash-completion.sh" \
		"${ED}/etc/profile.d/bash-completion.sh" || die "cp failed"

	dodir /usr/share/bash-completion
	mv "${ED}"/etc/bash_completion.d/* "${ED}/usr/share/bash-completion/" \
		|| die "installation failed to move files"
	awk -v D="$ED" '
	BEGIN { out=".pre" }
	/^# A lot of the following one-liners/ { out="base" }
	/^# start of section containing completion functions called by other functions/ { out=".pre" }
	/^# start of section containing completion functions for external programs/ { out="base" }
	/^# source completion directory/ { out="" }
	/^unset -f have/ { out=".post" }
	out != "" { print > D"/usr/share/bash-completion/"out }' \
	bash_completion || die "failed to split bash_completion"

	# clean up
	rm -r "${ED}"/etc/bash_completion{,.d} || die "rm failed"

	dodoc AUTHORS README TODO || die "dodocs failes"
}

pkg_postinst() {
	elog "Any user can enable the module completions without editing their"
	elog ".bashrc by running:"
	elog
	elog "    eselect bashcomp enable <module>"
	elog
	elog "The system administrator can also be enable this globally with"
	elog
	elog "    eselect bashcomp enable --global <module>"
	elog
	elog "Make sure you at least enable the base module! Additional completion"
	elog "modules can be found by running"
	elog
	elog "    eselect bashcomp list"
	elog
	elog "If you use non-login shells you still need to source"
	elog "/etc/profile.d/bash-completion.sh in your ~/.bashrc."

	if has_version 'app-shells/zsh' ; then
		elog "If you are interested in using the provided bash completion functions with"
		elog "zsh, valuable tips on the effective use of bashcompinit are available:"
		elog "  http://www.zsh.org/mla/workers/2003/msg00046.html"
		elog
	fi
}
