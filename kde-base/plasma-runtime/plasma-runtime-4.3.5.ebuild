# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/plasma-runtime/plasma-runtime-4.3.5.ebuild,v 1.4 2010/06/21 15:53:31 scarabeus Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="plasma"
inherit kde4-meta

DESCRIPTION="Script engine and package tool for plasma"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

# cloned from workspace thus introduce collisions.
add_blocker plasma-workspace '<4.2.90'
