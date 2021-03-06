# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/surround/surround-1.34.ebuild,v 1.3 2010/05/23 18:31:37 pacho Exp $

EAPI="2"

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: Delete/change/add parentheses/quotes/XML-tags/much more"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1697"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=8283 -> ${P}.zip"
LICENSE="as-is"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}"

VIM_PLUGIN_HELPFILES="${PN}"
VIM_PLUGIN_MESSAGES=""

DEPEND="app-arch/unzip"
RDEPEND=""
