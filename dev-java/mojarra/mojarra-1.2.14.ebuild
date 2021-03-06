# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mojarra/mojarra-1.2.14.ebuild,v 1.2 2010/02/23 22:47:47 nelchael Exp $

EAPI=3

WANT_ANT_TASKS="ant-trax"
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

MY_PV="$(get_version_component_range 1-2)_$(get_version_component_range 3)"

DESCRIPTION="Project Mojarra - GlassFish's Implementation for JavaServer Faces API"
HOMEPAGE="https://javaserverfaces.dev.java.net/"
SRC_URI="https://javaserverfaces.dev.java.net/files/documents/1866/146227/${PN}-${MY_PV}-source.zip
	mirror://gentoo/${PN}-${MY_PV}-patch.bz2"

LICENSE="CDDL"
SLOT="1.2"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="
	dev-java/commons-beanutils:1.6
	dev-java/commons-collections
	dev-java/commons-digester
	dev-java/commons-logging
	dev-java/glassfish-servlet-api:2.5
	dev-java/groovy
	dev-java/jakarta-jstl
	dev-java/portletapi:1
	"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	dev-java/ant-contrib
	dev-java/ant-trax
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-${MY_PV}-b01-FCS-sources"

src_prepare() {
	epatch "${DISTDIR}/${PN}-${MY_PV}-patch.bz2"

	mkdir -p "${S}/dependencies/jars" || die

	# Should we remove those files? I don't see a reason to pull in three
	# different web app server for this package.
	rm -f \
		"${S}/jsf-ri/src/com/sun/faces/vendor/GlassFishInjectionProvider.java" \
		"${S}/jsf-ri/src/com/sun/faces/vendor/Jetty6InjectionProvider.java" \
		"${S}/jsf-ri/src/com/sun/faces/vendor/Tomcat6InjectionProvider.java"

	find -name '*.jar' -exec rm -f {} \;

	cd "${S}/common/lib/"
	java-pkg_jarfrom --build-only ant-contrib

	cd "${S}/dependencies/jars"
	java-pkg_jarfrom commons-beanutils-1.6
	java-pkg_jarfrom commons-collections
	java-pkg_jarfrom commons-digester
	java-pkg_jarfrom commons-logging
	java-pkg_jarfrom glassfish-servlet-api-2.5
	java-pkg_jarfrom groovy
	java-pkg_jarfrom jakarta-jstl
	java-pkg_jarfrom portletapi-1
}

src_compile() {
	cd "${S}/jsf-api"
	eant -Djsf.build.home="${S}" -Dcontainer.name=glassfish jars

	cd "${S}/jsf-ri"
	eant -Djsf.build.home="${S}" -Dcontainer.name=glassfish jars
}

src_install() {
	java-pkg_dojar "${S}/jsf-api/build/lib/jsf-api.jar"
	java-pkg_dojar "${S}/jsf-ri/build/lib/jsf-impl.jar"
	use source && java-pkg_dosrc "${S}"/jsf-api/src/* "${S}"/jsf-ri/src/*
}
