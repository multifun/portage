# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libssh/libssh-0.4.0.ebuild,v 1.4 2010/01/18 19:02:09 armin76 Exp $

# Maintainer: check IUSE-defaults at DefineOptions.cmake

EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="http://www.libssh.org/"
SRC_URI="http://www.${PN}.org/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~hppa ~ppc ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="debug gcrypt examples +sftp ssh1 server static-libs zlib"

DEPEND="
	zlib? ( >=sys-libs/zlib-1.2 )
	!gcrypt? ( >=dev-libs/openssl-0.9.8 )
	gcrypt? ( >=dev-libs/libgcrypt-1.4 )
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS README ChangeLog"

src_prepare() {
	sed -i '/add_subdirectory(examples)/s/^/#DONOTWANT/' CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with debug DEBUG_CALLTRACE)
		$(cmake-utils_use_with debug DEBUG_CRYPTO)
		$(cmake-utils_use_with gcrypt)
		$(cmake-utils_use_with zlib LIBZ)
		$(cmake-utils_use_with sftp)
		$(cmake-utils_use_with ssh1)
		$(cmake-utils_use_with server)
		$(cmake-utils_use_with static-libs STATIC_LIB)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi
}
