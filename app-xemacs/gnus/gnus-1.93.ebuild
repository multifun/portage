# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/gnus/gnus-1.93.ebuild,v 1.1 2009/02/22 13:08:50 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="The Gnus Newsreader and Mailreader."
PKG_CAT="standard"

RDEPEND="app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/xemacs-eterm
app-xemacs/sh-script
app-xemacs/net-utils
app-xemacs/os-utils
app-xemacs/dired
app-xemacs/mh-e
app-xemacs/sieve
app-xemacs/ps-print
app-xemacs/w3
app-xemacs/pgg
app-xemacs/mailcrypt
app-xemacs/ecrypto
app-xemacs/sasl
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
