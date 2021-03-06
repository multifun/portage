# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/amanda/amanda-2.6.1_p2.ebuild,v 1.4 2010/05/08 19:48:53 robbat2 Exp $

inherit autotools eutils

MY_P="${P/_}"
DESCRIPTION="The Advanced Maryland Automatic Network Disk Archiver"
HOMEPAGE="http://www.amanda.org/"
SRC_URI="mirror://sourceforge/amanda/${MY_P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
RDEPEND="sys-libs/readline
	virtual/inetd
	sys-apps/gawk
	app-arch/tar
	>=dev-lang/perl-5.6
	app-arch/dump
	net-misc/openssh
	>=dev-libs/glib-2.2
	nls? ( virtual/libintl )
	s3? ( >=net-misc/curl-7.10.0 )
	samba? ( net-fs/samba )
	kerberos? ( app-crypt/mit-krb5 )
	xfs? ( sys-fs/xfsdump )
	!minimal? (
		virtual/mailx
		app-arch/mt-st
		sys-block/mtx
		gnuplot? ( sci-visualization/gnuplot )
		app-crypt/aespipe
		app-crypt/gnupg
	)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

IUSE="gnuplot ipv6 kerberos minimal nls s3 samba xfs"

S="${WORKDIR}/${MY_P}"

MYFILESDIR="${T}/files"
ENVDIR="/etc/env.d"
ENVDFILE="97amanda"
TMPENVFILE="${T}/${ENVDFILE}"

# This is a complete list of Amanda settings that the ebuild takes from the
# build environment. This allows users to alter the behavior of the package as
# upstream intended, but keeping with Gentoo style. We store a copy of them in
# /etc/env.d/97amanda during the install, so that they are preserved for future
# installed. This variable name must not start with AMANDA_, as we do not want
# it captured into the env file.
ENV_SETTINGS_AMANDA="
AMANDA_GROUP_GID AMANDA_GROUP_NAME
AMANDA_USER_NAME AMANDA_USER_UID AMANDA_USER_SH AMANDA_USER_HOMEDIR AMANDA_USER_GROUPS
AMANDA_SERVER AMANDA_SERVER_TAPE AMANDA_SERVER_INDEX
AMANDA_TAR_LISTDIR AMANDA_TAR
AMANDA_PORTS_UDP AMANDA_PORTS_TCP AMANDA_PORTS_BOTH AMANDA_PORTS
AMANDA_CONFIG_NAME AMANDA_TMPDIR"

amanda_variable_setup() {

	# Setting vars
	local currentamanda

	# Grab the current settings
	currentamanda="$(set | egrep "^AMANDA_" | grep -v '^AMANDA_ENV_SETTINGS' | xargs)"

	# First we set the defaults
	[ -z "${AMANDA_GROUP_GID}" ] && AMANDA_GROUP_GID=87
	[ -z "${AMANDA_GROUP_NAME}" ] && AMANDA_GROUP_NAME=amanda
	[ -z "${AMANDA_USER_NAME}" ] && AMANDA_USER_NAME=amanda
	[ -z "${AMANDA_USER_UID}" ] && AMANDA_USER_UID=87
	[ -z "${AMANDA_USER_SH}" ] && AMANDA_USER_SH=/bin/bash
	[ -z "${AMANDA_USER_HOMEDIR}" ] && AMANDA_USER_HOMEDIR=/var/spool/amanda
	[ -z "${AMANDA_USER_GROUPS}" ] && AMANDA_USER_GROUPS="${AMANDA_GROUP_NAME}"

	# This installs Amanda, with the server. However, it could be a client,
	# just specify an alternate server name in AMANDA_SERVER.
	[ -z "${AMANDA_SERVER}" ] && AMANDA_SERVER="${HOSTNAME}"
	[ -z "${AMANDA_SERVER_TAPE}" ] && AMANDA_SERVER_TAPE="${AMANDA_SERVER}"
	[ -z "${AMANDA_SERVER_INDEX}" ] && AMANDA_SERVER_INDEX="${AMANDA_SERVER}"
	[ -z "${AMANDA_TAR_LISTDIR}" ] && AMANDA_TAR_LISTDIR=${AMANDA_USER_HOMEDIR}/tar-lists
	[ -z "${AMANDA_CONFIG_NAME}" ] && AMANDA_CONFIG_NAME=DailySet1
	[ -z "${AMANDA_TMPDIR}" ] && AMANDA_TMPDIR=/var/tmp/amanda
	[ -z "${AMANDA_DBGDIR}" ] && AMANDA_DBGDIR="$AMANDA_TMPDIR"
	# These are left empty by default
	[ -z "${AMANDA_PORTS_UDP}" ] && AMANDA_PORTS_UDP=
	[ -z "${AMANDA_PORTS_TCP}" ] && AMANDA_PORTS_TCP=
	[ -z "${AMANDA_PORTS_BOTH}" ] && AMANDA_PORTS_BOTH=
	[ -z "${AMANDA_PORTS}" ] && AMANDA_PORTS=

	# What tar to use
	[ -z "${AMANDA_TAR}" ] && AMANDA_TAR=/bin/tar

	# Now pull in the old stuff
	if [ -f "${ROOT}${ENVDIR}/${ENVDFILE}" ]; then
		# We don't just source it as we don't want everything in there.
		eval $(egrep "^AMANDA_" "${ROOT}${ENVDIR}/${ENVDFILE}" | grep -v '^AMANDA_ENV_SETTINGS')
	fi

	# Re-apply the new settings if any
	[ -n "${currentamanda}" ] && eval `echo "${currentamanda}"`

}

pkg_setup() {
	amanda_variable_setup
	enewgroup "${AMANDA_GROUP_NAME}" "${AMANDA_GROUP_GID}"
	enewuser "${AMANDA_USER_NAME}" "${AMANDA_USER_UID}" "${AMANDA_USER_SH}" "${AMANDA_USER_HOMEDIR}" "${AMANDA_USER_GROUPS}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix a fun race condition if you use encryption.
	# This is one of the reasons you should test your recovery procedures often.
	epatch "${FILESDIR}"/${PN}-2.6.0p2-amcrypt-ossl-asym-race-fix.patch

	# gentoo bug 248838, check /sbin stuff before /bin
	epatch "${FILESDIR}"/${PN}-2.6.0_p2-syslocpath.patch

	eautoreconf

	# places for us to work in
	mkdir -p "${MYFILESDIR}"
	# Now we store the settings we just created
	set | egrep "^AMANDA_" | grep -v '^AMANDA_ENV_SETTINGS' > "${TMPENVFILE}"

	# Prepare our custom files
	einfo "Building custom configuration files"
	local i # our iterator
	local sedexpr # var for sed expr
	sedexpr=''
	for i in ${ENV_SETTINGS_AMANDA} ; do
		local val
		eval "val=\"\${${i}}\""
		sedexpr="${sedexpr}s|__${i}__|${val}|g;"
	done

	# now apply the sed expr
	for i in "${FILESDIR}"/amanda-* ; do
		sed -re "${sedexpr}" <"${i}" >"${MYFILESDIR}/`basename ${i}`"
	done

	(
		cat "${MYFILESDIR}"/amanda-amandahosts-client-2.5.1_p3-r1
		use minimal || cat "${MYFILESDIR}"/amanda-amandahosts-server-2.5.1_p3-r1
	) > "${T}"/amandahosts
}

src_compile() {
	# fix bug #36316
	addpredict /var/cache/samba/gencache.tdb

	[ ! -f "${TMPENVFILE}" ] && die "Variable setting file (${TMPENVFILE}) should exist!"
	source "${TMPENVFILE}"
	local myconf

	einfo "Using ${AMANDA_SERVER_TAPE} for tape server."
	myconf="${myconf} --with-tape-server=${AMANDA_SERVER_TAPE}"
	einfo "Using ${AMANDA_SERVER_INDEX} for index server."
	myconf="${myconf} --with-index-server=${AMANDA_SERVER_INDEX}"
	einfo "Using ${AMANDA_USER_NAME} for amanda user."
	myconf="${myconf} --with-user=${AMANDA_USER_NAME}"
	einfo "Using ${AMANDA_GROUP_NAME} for amanda group."
	myconf="${myconf} --with-group=${AMANDA_GROUP_NAME}"
	einfo "Using ${AMANDA_TAR} as Tar implementation."
	myconf="${myconf} --with-gnutar=${AMANDA_TAR}"
	einfo "Using ${AMANDA_TAR_LISTDIR} as tar listdir."
	myconf="${myconf} --with-gnutar-listdir=${AMANDA_TAR_LISTDIR}"
	einfo "Using ${AMANDA_CONFIG_NAME} as default config name."
	myconf="${myconf} --with-config=${AMANDA_CONFIG_NAME}"
	einfo "Using ${AMANDA_TMPDIR} as Amanda temporary directory."
	myconf="${myconf} --with-tmpdir=${AMANDA_TMPDIR}"

	if [ -n "${AMANDA_PORTS_UDP}" ] && [ -n "${AMANDA_PORTS_TCP}" ] && [ -z "${AMANDA_PORTS_BOTH}" ] ; then
		eerror "If you want _both_ UDP and TCP ports, please use only the"
		eerror "AMANDA_PORTS environment variable for identical ports, or set"
		eerror "AMANDA_PORTS_BOTH."
		die "Bad port setup!"
	fi
	if [ -n "${AMANDA_PORTS_UDP}" ]; then
		einfo "Using UDP ports ${AMANDA_PORTS_UDP/,/-}"
		myconf="${myconf} --with-udpportrange=${AMANDA_PORTS_UDP}"
	fi
	if [ -n "${AMANDA_PORTS_TCP}" ]; then
		einfo "Using TCP ports ${AMANDA_PORTS_TCP/,/-}"
		myconf="${myconf} --with-tcpportrange=${AMANDA_PORTS_TCP}"
	fi
	if [ -n "${AMANDA_PORTS}" ]; then
		einfo "Using ports ${AMANDA_PORTS/,/-}"
		myconf="${myconf} --with-portrange=${AMANDA_PORTS}"
	fi

	# Extras
	# Speed option
	myconf="${myconf} --with-buffered-dump"
	# "debugging" in the configuration is NOT debug in the conventional sense.
	# It is actually just useful output in the application, and should remain
	# enabled. There are some cases of breakage with MTX tape changers as of
	# 2.5.1p2 that it exposes when turned off as well.
	myconf="${myconf} --with-debugging"
	# Where to put our files
	myconf="${myconf} --localstatedir=${AMANDA_USER_HOMEDIR}"

	# Samba support
	myconf="${myconf} `use_with samba smbclient /usr/bin/smbclient`"

	# Support for BSD, SSH, BSDUDP, BSDTCP security methods all compiled in by
	# default
	myconf="${myconf} --with-bsd-security"
	myconf="${myconf} --with-ssh-security"
	myconf="${myconf} --with-bsdudp-security"
	myconf="${myconf} --with-bsdtcp-security"

	# kerberos-security mechanism version 4
	# always disable, per bug #173354
	myconf="${myconf} --without-krb4-security"

	# kerberos-security mechanism version 5
	myconf="${myconf} `use_with kerberos krb5-security`"

	# Amazon S3 support
	myconf="${myconf} `use_enable s3 s3-device`"

	# Client only, as requested in bug #127725
	if use minimal ; then
		myconf="${myconf} --without-server"
	else
		# amplot
		myconf="${myconf} $(use_with gnuplot)"
	fi

	# IPv6 fun.
	myconf="${myconf} `use_with ipv6`"

	# I18N
	myconf="${myconf} `use_enable nls`"

	econf ${myconf} || die "econf failed!"
	emake || die "emake failed!"
}

src_install() {
	[ ! -f "${TMPENVFILE}" ] && die "Variable setting file (${TMPENVFILE}) should exist!"
	source ${TMPENVFILE}

	einfo "Doing stock install"
	# parallel make install b0rked
	emake -j1 DESTDIR="${D}" install || die

	# Build the envdir file
	# Don't forget this..
	einfo "Building environment file"
	(
		echo "# These settings are what was present in the environment when this"
		echo "# Amanda was compiled.  Changing anything below this comment will"
		echo "# have no effect on your application, but it merely exists to"
		echo "# preserve them for your next emerge of Amanda"
		cat "${TMPENVFILE}" | sed "s,=\$,='',g"
	) >> "${MYFILESDIR}/${ENVDFILE}"

	# Env.d
	einfo "Installing environment config file"
	doenvd "${MYFILESDIR}/${ENVDFILE}"

	# Lock down next section (up until docs).
	insopts -m0640
	# Installing Amanda Xinetd Services Definition
	einfo "Installing xinetd service file"
	insinto /etc/xinetd.d
	if use minimal ; then
		newins "${MYFILESDIR}"/amanda-xinetd-${PV}-client amanda
	else
		newins "${MYFILESDIR}"/amanda-xinetd-${PV}-server amanda
	fi

	einfo "Installing Sample Daily Cron Job for Amanda"
	insinto /etc/cron.daily
	newins "${MYFILESDIR}/amanda-cron" amanda

	insinto /etc/amanda
	einfo "Installing .amandahosts File for ${AMANDA_USER_NAME} user"
	doins "${T}/amandahosts"
	fperms 600 /etc/amanda/amandahosts

	dosym /etc/amanda/amandahosts "${AMANDA_USER_HOMEDIR}/.amandahosts"
	insinto "${AMANDA_USER_HOMEDIR}"
	einfo "Installing .profile for ${AMANDA_USER_NAME} user"
	newins "${MYFILESDIR}/amanda-profile" .profile

	insinto /etc/amanda
	doins "${S}/example/amanda-client.conf"
	if ! use minimal ; then
		insinto "/etc/amanda/${AMANDA_CONFIG_NAME}"
		doins "${S}/example/amanda.conf"
		doins "${S}/example/disklist"
		keepdir "${AMANDA_USER_HOMEDIR}/${AMANDA_CONFIG_NAME}/index"
	fi

	keepdir "${AMANDA_TAR_LISTDIR}"
	keepdir "${AMANDA_USER_HOMEDIR}/amanda"
	keepdir "${AMANDA_TMPDIR}/dumps"
	# Just make sure it exists for XFS to work...
	use xfs && keepdir /var/xfsdump/inventory

	local i
	for i in "${AMANDA_USER_HOMEDIR}" "${AMANDA_TAR_LISTDIR}" \
		"${AMANDA_TMPDIR}" /etc/amanda; do
		einfo "Securing directory (${i})"
		fowners -R ${AMANDA_USER_NAME}:${AMANDA_GROUP_NAME} ${i}
	done
	# Do NOT use -R
	fperms 0700 \
		"${AMANDA_USER_HOMEDIR}" "${AMANDA_TAR_LISTDIR}" \
		"${AMANDA_TMPDIR}" "${AMANDA_TMPDIR}/dumps" \
		 "${AMANDA_USER_HOMEDIR}/amanda" \
		 "${AMANDA_USER_HOMEDIR}/${AMANDA_CONFIG_NAME}" \
		 /etc/amanda /etc/amanda/${AMANDA_CONFIG_NAME}

	einfo "Setting setuid permissions"
	amanda_permissions_fix "${D}"

	# Relax permissions again
	insopts -m0644

	# docs
	einfo "Installing documentation"
	dodoc AUTHORS ChangeLog DEVELOPING NEWS README ReleaseNotes UPGRADING
	# our inetd sample
	einfo "Installing standard inetd sample"
	newdoc "${MYFILESDIR}/amanda-inetd.amanda.sample-2.6.0_p2-r2" amanda-inetd.amanda.sample
	# Amanda example configs
	einfo "Installing example configurations"
	rm "${D}"/usr/share/amanda/{COPYRIGHT,ChangeLog,NEWS,ReleaseNotes}
	mv "${D}/usr/share/amanda/example" "${D}/usr/share/doc/${PF}/"
	docinto example1
	newdoc "${FILESDIR}/example_amanda.conf" amanda.conf
	newdoc "${FILESDIR}/example_disklist-2.5.1_p3-r1" disklist
	newdoc "${FILESDIR}/example_global.conf" global.conf
}

pkg_postinst() {
	[ ! -f "${TMPENVFILE}" -a "$EMERGE_FROM" == "binary" ] && \
		TMPENVFILE="${ROOT}${ENVDIR}/${ENVDFILE}"
	[ ! -f "${TMPENVFILE}" ] && die "Variable setting file (${TMPENVFILE}) should exist!"
	source "${TMPENVFILE}"

	# Migration of amandates from /etc to $localstatedir/amanda
	if [ -f "${ROOT}/etc/amandates" -a \
		! -f "${ROOT}/${AMANDA_USER_HOMEDIR}/amanda/amandates" ]; then
		einfo "Migrating amandates from /etc/ to ${AMANDA_USER_HOMEDIR}/amanda"
		einfo "A backup is also placed at /etc/amandates.orig"
		cp -dp "${ROOT}/etc/amandates" "${ROOT}/etc/amandates.orig"
		mkdir -p "${ROOT}/${AMANDA_USER_HOMEDIR}/amanda/"
		cp -dp "${ROOT}/etc/amandates" "${ROOT}/${AMANDA_USER_HOMEDIR}/amanda/amandates"
	fi
	if [ -f "${ROOT}/etc/amandates" ]; then
		einfo "If you have migrated safely, please delete /etc/amandates"
	fi

	# If USE=minimal, give out a warning, if AMANDA_SERVER is not set to
	# another host than HOSTNAME.
	if use minimal && [ "${AMANDA_SERVER}" = "${HOSTNAME}" ] ; then
		elog "You are installing a client-only version of Amanda."
		elog "You should set the variable \$AMANDA_SERVER to point at your"
		elog "Amanda-tape-server, otherwise you will have to specify its name"
		elog "when using amrecover on the client."
		elog "For example: Use something like"
		elog "AMANDA_SERVER=\"myserver\" emerge amanda"
		elog
	fi

	einfo "Checking setuid permissions"
	amanda_permissions_fix "${ROOT}"

	elog "You should configure Amanda in /etc/amanda now."
	elog
	elog "If you use xinetd, Don't forget to check /etc/xinetd.d/amanda"
	elog "and restart xinetd afterwards!"
	elog
	elog "Otherwise, please look at /usr/share/doc/${PF}/inetd.amanda.sample"
	elog "as an example of how to configure your inetd."
	elog
	elog "NOTICE: If you need raw access to partitions you need to add the"
	elog "amanda user to the 'disk' group."
	elog
	elog "NOTICE: If you have a tape changer, you need to add the amanda user"
	elog "to the 'tape' group."
	elog
	elog "If you use localhost in your disklist your restores may break."
	elog "You should replace it with the actual hostname!"
	elog "Please also see the syntax changes to amandahosts."
}

# We have had reports of amanda file permissions getting screwed up.
# Losing setuid, becoming too lax etc.
# ONLY root and users in the amanda group should be able to run these binaries!
amanda_permissions_fix() {
	local root="$1"
	[ -z "${root}" ] && die "Failed to pass root argument to amanda_permissions_fix!"
	local le="/usr/libexec/amanda"
	for i in /usr/sbin/amcheck "${le}"/calcsize "${le}"/killpgrp \
		"${le}"/rundump "${le}"/runtar "${le}"/dumper \
		"${le}"/planner ; do
		chown root:${AMANDA_GROUP_NAME} "${root}"/${i}
		chmod u=srwx,g=rx,o= "${root}"/${i}
	done
}
