# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-wizards/kdepim-wizards-4.2.1.ebuild,v 1.1 2009/03/04 21:11:03 alexxy Exp $

EAPI="2"

KMNAME="kdepim"
KMMODULE="wizards"
inherit kde4-meta

DESCRIPTION="KDE PIM wizards"
IUSE="debug"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="app-crypt/gpgme:1
	kde-base/kdepim-kresources:${SLOT}
	kde-base/libkdepim:${SLOT}"

KMEXTRACTONLY="knotes/
	kmail/
	kresources/egroupware/
	kresources/groupwise/
	kresources/kolab/
	kresources/scalix/
	kresources/slox/
	libkdepim"

src_unpack() {
	kde4-meta_src_unpack

	ln -s "${PREFIX}"/include/kdepim-kresources/{kabc,kcal,knotes}_egroupwareprefs.h \
		"${WORKDIR}"/${P}/kresources/egroupware/ \
		|| die "Failed to link extra_headers."
	ln -s "${PREFIX}"/include/kdepim-kresources/{kabcsloxprefs.h,kcalsloxprefs.h} \
		"${WORKDIR}"/${P}/kresources/slox/ \
		|| die "Failed to link extra_headers."
	ln -s "${PREFIX}"/include/kdepim-kresources/{kabc_groupwiseprefs,kcal_groupwiseprefsbase}.h \
		"${WORKDIR}"/${P}/kresources/groupwise/ \
		|| die "Failed to link extra_headers."
}
