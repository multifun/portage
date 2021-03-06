# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontact/kontact-4.3.5.ebuild,v 1.4 2010/06/21 15:53:25 scarabeus Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE personal information manager"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

DEPEND="
	app-crypt/gpgme
	$(add_kdebase_dep kontactinterfaces)
	$(add_kdebase_dep libkdepim)
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

KMLOADLIBS="libkdepim"
KMSAVELIBS="true"

# We remove plugins that are related to external kdepim programs. This way
# kontact doesn't have to depend on all programs it has plugins for.
#
# xml targets from kmail/ are being uncommented by kde4-meta.eclass
KMEXTRACTONLY="
	kmail/
	kontact/plugins/akregator/
	kontact/plugins/kaddressbook/
	kontact/plugins/kjots/
	kontact/plugins/kmail/
	kontact/plugins/knode/
	kontact/plugins/knotes/
	kontact/plugins/korganizer/
	kontact/plugins/ktimetracker/
	kontact/plugins/planner/
	kontact/plugins/specialdates/
	kontactinterfaces/
"
