# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk/asterisk-1.6.2.7.ebuild,v 1.2 2010/06/17 20:56:41 patrick Exp $

EAPI=3
inherit autotools base eutils linux-info

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.digium.com/pub/telephony/asterisk/releases/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa +caps curl dahdi debug freetds iconv jabber ldap keepsrc misdn newt +samples oss postgres radius snmp span speex ssl sqlite static vorbis"

RDEPEND="sys-libs/ncurses
	dev-libs/popt
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	caps? ( sys-libs/libcap )
	curl? ( net-misc/curl )
	dahdi? ( >=net-libs/libpri-1.4.7
		net-misc/dahdi-tools )
	freetds? ( dev-db/freetds )
	iconv? ( virtual/libiconv )
	jabber? ( dev-libs/iksemel )
	ldap?	( net-nds/openldap )
	misdn? ( net-dialup/misdnuser )
	newt? ( dev-libs/newt )
	postgres? ( dev-db/postgresql-base )
	radius? ( net-dialup/radiusclient-ng )
	snmp? ( net-analyzer/net-snmp )
	span? ( media-libs/spandsp )
	speex? ( media-libs/speex )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	vorbis? ( media-libs/libvorbis )"

DEPEND="${RDEPEND}
	!<net-misc/asterisk-addons-1.6
	!net-misc/asterisk-chan_unistim
	!net-misc/zaptel"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/1.6.2/${P}-gsm-pic.patch"
	"${FILESDIR}/1.6.2/${P}-pri-missing-keyword.patch"
	"${FILESDIR}/1.6.1/${PN}-1.6.1-uclibc.patch"
	"${FILESDIR}/1.6.1/${PN}-1.6.1.6-fxsks-hookstate.patch"
	"${FILESDIR}/1.6.2/${PN}-1.6.2.2-nv-faxdetect.patch"
)

get_available_modules() {
	local modules mod x

	# build list of available modules...
	for x in app cdr codec format func pbx res; do

		for mod in $(find "${S}" -type f -name "${x}_*.c*" -print)
		do
			modules="${modules} $(basename ${mod/%.c*})"
		done
	done

	echo "${modules}"
}

pkg_setup() {
	if [[ -n "${ASTERISK_MODULES}" ]] ; then
		ewarn "You are overriding ASTERISK_MODULES. We will assume you know what you are doing. There is no support for this option, try without if you see breakage."
	fi
	CONFIG_CHECK="~!NF_CONNTRACK_SIP"
	local WARNING_NF_CONNTRACK_SIP="SIP (NAT) connection tracking is a module written for a single SIP client talking to a
	remote server. It is not able to track multiple remote SIP clients registering with
	a local server. Critical SIP packets may be dropped."
	check_extra_config

	# parse modules list
	if [[ -n "${ASTERISK_MODULES}" ]]; then
		local x modules="$(get_available_modules)"

		einfo "Custom list of modules specified, checking..."

		use debug && {
			einfo "Available modules: ${modules}"
			einfo " Selected modules: ${ASTERISK_MODULES}"
		}

		for x in ${ASTERISK_MODULES}; do
			if [[ "${x}" = "-*" ]]; then
				MODULES_LIST=""
			else
				if has ${x} ${modules}
				then
					MODULES_LIST="${MODULES_LIST} ${x}"
				else
					eerror "Unknown module: ${x}"
				fi
			fi
		done

		export MODULES_LIST
	fi
}

src_prepare() {
	base_src_prepare
	AT_M4DIR=autoconf eautoreconf
}

src_configure() {
	econf \
		--libdir="/usr/$(get_libdir)" \
		--localstatedir="/var" \
		--with-gsm=internal \
		--with-popt \
		--with-z \
		$(use_with alsa asound) \
		$(use_with caps cap) \
		$(use_with curl) \
		$(use_with dahdi pri) \
		$(use_with dahdi tonezone) \
		$(use_with dahdi) \
		$(use_with freetds tds) \
		$(use_with iconv) \
		$(use_with jabber iksemel) \
		$(use_with misdn isdnnet) \
		$(use_with misdn suppserv) \
		$(use_with misdn) \
		$(use_with newt) \
		$(use_with oss) \
		$(use_with postgres) \
		$(use_with radius) \
		$(use_with snmp netsnmp) \
		$(use_with span spandsp) \
		$(use_with speex) \
		$(use_with speex speexdsp) \
		$(use_with sqlite sqlite3) \
		$(use_with ssl crypto) \
		$(use_with ssl) \
		$(use_with vorbis ogg) \
		$(use_with vorbis) || die "econf failed"

	#
	# custom module filter
	# run menuselect to evaluate the list of modules
	# and rewrite the list afterwards
	#
	if [[ -n "${MODULES_LIST}" ]]
	then
		local mod category tmp_list failed_list

		###
		# run menuselect

		emake menuselect.makeopts || die "emake menuselect.makeopts failed"

		###
		# get list of modules with failed dependencies

		failed_list="$(awk -F= '/^MENUSELECT_DEPSFAILED=/{ print $3 }' menuselect.makeopts)"

		###
		# traverse our list of modules

		for category in app cdr codec format func pbx res; do
			tmp_list=""

			# search list of modules for matching ones first...
			for mod in ${MODULES_LIST}; do
				# module is from current category?
				if [[ "${mod/%_*}" = "${category}" ]]
				then
					# check menuselect thinks the dependencies are met
					if has ${mod} ${failed_list}
					then
						eerror "${mod}: dependencies required to build this module are not met, NOT BUILDING!"
					else
						tmp_list="${tmp_list} ${mod}"
					fi
				fi
			done

			use debug && echo "${category} tmp: ${tmp_list}"

			# replace the module list for $category with our custom one
			if [[ -n "${tmp_list}" ]]
			then
				category="$(echo ${category} | tr '[:lower:]' '[:upper:]')"
				sed -i -e "s:^\(MENUSELECT_${category}S?\):\1=${tmp_list}:" \
					menuselect.makeopts || die "failed to set list of ${category} applications"
			fi
		done
	fi
}

src_compile() {
	ASTLDFLAGS="${LDFLAGS}" emake || die "emake failed"
}

src_install() {
	# setup directory structure
	#
	mkdir -p "${D}"usr/lib/pkgconfig

	emake DESTDIR="${D}" install || die "emake install failed"

	if use samples; then
		emake DESTDIR="${D}" samples || die "emake samples failed"
		for conffile in "${D}"etc/asterisk/*.*
		do
			fowners asterisk:asterisk $conffile
			fperms 0660 $conffile
		done
		einfo "Sample files have been installed"
	else
		einfo "Skipping installation of sample files..."
		rm -f  "${D}"var/lib/asterisk/mohmp3/*
		rm -f  "${D}"var/lib/asterisk/sounds/demo-*
		rm -f  "${D}"var/lib/asterisk/agi-bin/*
		rm -f  "${D}"etc/asterisk/*
	fi
	rm -rf "${D}"var/spool/asterisk/voicemail/default

	# keep directories
	diropts -m 0770 -o asterisk -g asterisk
	keepdir	/etc/asterisk
	keepdir /var/lib/asterisk
	keepdir /var/run/asterisk
	keepdir /var/spool/asterisk
	keepdir /var/spool/asterisk/{system,tmp,meetme,monitor,dictate,voicemail}
	diropts -m 0750 -o asterisk -g asterisk
	keepdir /var/log/asterisk/{cdr-csv,cdr-custom}

	newinitd "${FILESDIR}"/1.6.1/asterisk.initd3 asterisk
	newconfd "${FILESDIR}"/1.6.0/asterisk.confd asterisk

	# some people like to keep the sources around for custom patching
	# copy the whole source tree to /usr/src/asterisk-${PVF} and run make clean there
	if use keepsrc
	then
		dodir /usr/src

		ebegin "Copying sources into /usr/src"
		cp -dPR "${S}" "${D}"/usr/src/${PF} || die "Unable to copy sources"
		eend $?

		ebegin "Cleaning source tree"
		emake -C "${D}"/usr/src/${PF} clean &>/dev/null || die "Unable to clean sources"
		eend $?

		einfo "Clean sources are available in "${ROOT}"usr/src/${PF}"
	fi

	# install the upgrade documentation
	#
	dodoc README UPGRADE* BUGS CREDITS

	# install snmp mib files
	#
	if use snmp
	then
		insinto /usr/share/snmp/mibs/
		doins doc/digium-mib.txt doc/asterisk-mib.txt
	fi
}

pkg_preinst() {
	enewgroup asterisk
	enewuser asterisk -1 -1 /var/lib/asterisk "asterisk,dialout"
}

pkg_postinst() {
	#
	# Announcements, warnings, reminders...
	#
	einfo "Asterisk has been installed"
	echo
	elog "If you want to know more about asterisk, visit these sites:"
	elog "http://www.asteriskdocs.org/"
	elog "http://www.voip-info.org/wiki-Asterisk"
	echo
	elog "http://www.automated.it/guidetoasterisk.htm"
	echo
	elog "Gentoo VoIP IRC Channel:"
	elog "#gentoo-voip @ irc.freenode.net"
	echo
	echo
	elog "1.6.1 -> 1.6.2 changes that you may care about:"
	elog "canreinvite -> directmedia (sip.conf)"
	elog "extensive T.38 (fax) changes"
	elog "http://svn.asterisk.org/svn/${PN}/tags/${PV}/UPGRADE.txt"
	elog "or: bzless ${ROOT}usr/share/doc/${PF}/UPGRADE.txt.bz2"
}

pkg_config() {
	einfo "Do you want to reset file permissions and ownerships (y/N)?"

	read tmp
	tmp="$(echo $tmp | tr '[:upper:]' '[:lower:]')"

	if [[ "$tmp" = "y" ]] ||\
		[[ "$tmp" = "yes" ]]
	then
		einfo "Resetting permissions to defaults..."

		for x in spool run lib log; do
			chown -R asterisk:asterisk "${ROOT}"var/${x}/asterisk
			chmod -R u=rwX,g=rwX,o=    "${ROOT}"var/${x}/asterisk
		done

		chown -R root:asterisk  "${ROOT}"etc/asterisk
		chmod -R u=rwX,g=rwX,o= "${ROOT}"etc/asterisk

		einfo "done"
	else
		einfo "skipping"
	fi
}
