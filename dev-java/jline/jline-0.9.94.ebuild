# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jline/jline-0.9.94.ebuild,v 1.1 2009/05/21 21:47:36 caster Exp $

EAPI=2
JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java library for handling console input"
HOMEPAGE="http://jline.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${P}/src"

java_prepare() {
	rm -fv "${WORKDIR}"/${P}/*.jar || die

	# we don't support maven for building yet. this build.xml was generated by:
	# - mvn ant:ant
	# - tweak build.xml to not load properties from home dir
	# - tweak the test target to match the test cases
	# - change maven.repo.local from ~/.maven to "lib" in .properties
	# - change classpath definitions to "*.jar"
	cp "${FILESDIR}/maven-build.xml" build.xml || die
	cp "${FILESDIR}/maven-build.properties" . || die
	java-ant_ignore-system-classes

	mkdir lib && cd lib || die
	use test && java-pkg_jar-from --build-only junit
}

src_compile() {
	# precompiled javadocs (needs maven to generate)
	# -Dmaven.build.finalName is needed to override the one defined in the
	# build.xml, which because it was generated with 0.9.9, defaults to
	# jline-0.9.9 -nichoj
	eant package -Dmaven.build.finalName=${P}
}

src_test() {
	ANT_TASKS="ant-junit" eant test -Djunit.present=true
}

src_install() {
	java-pkg_newjar target/${P}.jar
	use doc && java-pkg_dojavadoc ../apidocs
	use source && java-pkg_dosrc src/main/java
}

