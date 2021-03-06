# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/php-docs/php-docs-20100326.ebuild,v 1.1 2010/03/31 22:02:32 mabi Exp $

EAPI="1"

DESCRIPTION="HTML documentation for PHP"
HOMEPAGE="http://www.php.net/download-docs.php"

MY_PN="php_manual"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="+linguas_en"
SRC_URI="linguas_en? ( mirror://php/distributions/manual/${MY_PN}_en.tar.gz )"

RESTRICT="strip binchecks"

LANGS="bg de fr ja ko pl pt_BR ro tr"
for lang in ${LANGS} ; do
	IUSE="${IUSE} linguas_${lang}"
	SRC_URI="${SRC_URI}
		linguas_${lang}? ( mirror://php/distributions/manual/${MY_PN}_${lang}.tar.gz )"
done

S=${WORKDIR}

src_unpack() {
	for lang in en ${LANGS} ; do
		if use linguas_${lang} ; then
			mkdir ${lang}
			pushd ${lang} >/dev/null
			unpack ${MY_PN}_${lang}.tar.gz || die "unpack failed on ${lang}"
			popd >/dev/null
		fi
	done
}

pkg_preinst() {
	# remove broken/stale symlink created by previous ebuilds
	[[ -L ${ROOT}/usr/share/php-docs ]] && rm -f "${ROOT}"/usr/share/php-docs
}

src_install() {
	dodir /usr/share/doc/${PF}

	for lang in en ${LANGS} ; do
		if use linguas_${lang} ; then
			ebegin "Installing ${lang} manual, will take a while"
			cp -R "${WORKDIR}"/${lang} "${D}"/usr/share/doc/${PF} || die "cp failed on ${lang}"
			eend $?
		fi
	done

	einfo "Creating symlink to PHP manual at /usr/share/php-docs"
	dosym /usr/share/doc/${PF} /usr/share/php-docs
}
