# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlalchemy/sqlalchemy-0.5.8.ebuild,v 1.1 2010/01/17 17:59:20 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="SQLAlchemy-${PV/_/}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper."
HOMEPAGE="http://www.sqlalchemy.org/ http://pypi.python.org/pypi/SQLAlchemy"
SRC_URI="http://pypi.python.org/packages/source/S/SQLAlchemy/SQLAlchemy-0.6beta1.tar.gz mirror://sourceforge/${PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"
LICENSE="MIT"
SLOT="0"
IUSE="doc examples firebird mssql mysql postgres +sqlite test"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND="firebird? ( dev-python/kinterbasdb )
	mssql? ( dev-python/pymssql )
	mysql? ( dev-python/mysql-python )
	postgres? (
		>=dev-python/psycopg-2
	)
	sqlite? (
		>=dev-db/sqlite-3.3.13
		|| ( >=dev-lang/python-2.5[sqlite] dev-python/pysqlite )
	)"

DEPEND="dev-python/setuptools
	test? (
		>=dev-db/sqlite-3.3.13
		>=dev-python/nose-0.10.4
		|| ( >=dev-lang/python-2.5[sqlite] dev-python/pysqlite )
	)"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="lib" nosetests-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use doc; then
		pushd doc > /dev/null
		rm -fr build
		dohtml -r [a-z]* _images _static
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
