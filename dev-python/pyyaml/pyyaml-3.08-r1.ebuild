# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyyaml/pyyaml-3.08-r1.ebuild,v 1.1 2009/08/29 23:21:53 arfrever Exp $

EAPI="2"

NEED_PYTHON="2.3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="PyYAML-${PV}"

DESCRIPTION="YAML parser and emitter for Python"
HOMEPAGE="http://pyyaml.org/wiki/PyYAML"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="examples libyaml"

DEPEND="libyaml? ( dev-libs/libyaml dev-python/pyrex )"
RDEPEND="libyaml? ( dev-libs/libyaml )"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="yaml"

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/.
	fi
}
