# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/net-ssh-multi/net-ssh-multi-1.0.1.ebuild,v 1.1 2009/02/25 21:09:07 robbat2 Exp $

inherit gems

DESCRIPTION="Net::SSH::Multi is a library for controlling multiple Net::SSH
connections via a single interface."
HOMEPAGE="http://net-ssh.rubyforge.org/multi"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-ruby/net-ssh-2.0.10"
