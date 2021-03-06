# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-vfs-python/gnome-vfs-python-2.26.1.ebuild,v 1.10 2010/01/17 23:40:03 jer Exp $

G_PY_PN="gnome-python"
G_PY_BINDINGS="gnomevfs gnomevfsbonobo pyvfsmodule"

inherit gnome-python-common

DESCRIPTION="Python bindings for the GnomeVFS library"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc examples"

RDEPEND=">=gnome-base/gnome-vfs-2.24.0
	>=gnome-base/libbonobo-2.8
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES="examples/vfs/*
	examples/vfs/pygvfsmethod/"
