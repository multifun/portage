# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit multilib

DESCRIPTION="Filesystem baselayout and init scripts"
HOMEPAGE="http://www.funtoo.org/"
SRC_URI="http://www.funtoo.org/archive/baselayout/baselayout-2.1.1.tar.bz2"
S=$WORKDIR/baselayout-2.1.1

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc sparc-fbsd x86 x86-fbsd"
IUSE="build"

PDEPEND="sys-apps/openrc"

pkg_preinst() {
	# execute critical sub-functions (defined elsewhere in this ebuild):

	# migrate to new modules.conf filenames:
	
	modfix

	# create initial set of library directories if appropriate:

	create_lib_dirs
}

create_lib_dirs() {
	
	# Only do this for non-root filesystems. Also note that all filesystem-
	# modifying commands below will only execute if the target file does
	# not already exist. This should provide reasonable protection for existing
	# installations that may differ from these norms.

	[ "$ROOT" = "/" ] && return 0

	# Get a list of libdirs for this ABI. For amd64, this list would be
	# "lib lib64 lib32".

	local libdirs="$(get_all_libdirs)" dir=

	# This following shell construction will set $libdirs to "lib" if it
	# is blank:

	: ${libdirs:=lib}	

	# Now, we iterate over our lib dirs, creating one in /, /usr and
	# /usr/local:

	for dir in ${libdirs} 
	do
		
		# If SYMLINK_LIB is set, this means that the "lib" dirs should be
		# created as  symlinks, so don't create real "lib" dirs in this case.
		# For example, on amd64 multilib (the default,) SYMLINK_LIB is set to
		# "yes" which means that /lib, /usr/lib and /usr/local/lib are symlinks
		# to "lib64" (in the current directory.) We will create these symlinks
		# as necessary later.

		[ "$dir" = "lib" ] && [ "$SYMLINK_LIB" = "yes" ] && continue

		[ -e ${ROOT}${dir} ] || install -d ${ROOT}${dir} || die
		[ -e ${ROOT}usr/${dir} ] || install -d ${ROOT}usr/${dir} || die
		[ -e ${ROOT}usr/local${dir} ] || install -d ${ROOT}usr/local/${dir} || die
	done

	# if SYMLINK_LIB is set, we are going to create "lib" symlinks pointing
	# to the libdir for the DEFAULT_ABI (this would be "lib64" for an arch
	# of amd64:

	if [ "$SYMLINK_LIB" = "yes" ]
	then
		dir=$(get_abi_LIBDIR "${DEFAULT_ABI}")

		# If the "lib" target doesn't exist, then create a "lib" link
		# pointing to something like "lib64" (libdir of the DEFAULT_ABI)
		
		[ -e ${ROOT}lib ] || ln -sf ${dir} ${ROOT}lib || die
		[ -e ${ROOT}usr/lib ] || ln -sf ${dir} ${ROOT}usr/lib || die
		[ -e ${ROOT}usr/local/lib ] || ln -sf ${dir} ${ROOT}usr/local/lib || die
	fi

	# At this point, we should have a correctly-configured base set of library
	# directories.
}

src_compile() {
	return 0
}

modfix() {
	local mod

	# We want to move any old modprobe.d conf files that were installed by
	# earlier baselayouts to the new file name so that config file protection
	# works correctly when we merge the "new style" filenames.

	for mod in i386 aliases 
	do
		if [ -e $ROOT/etc/modprobe.d/$mod ] 
		then
			mv $ROOT/etc/modprobe.d/$mod $ROOT/etc/modprobe.d/${mod}.conf || die "mv failed"
		fi
	done

}

src_install() {
	local libdir="lib"
	local rcscripts_dir="/lib/rcscripts"

	if [ ${SYMLINK_LIB} == "yes" ]; then
		libdir=$(get_abi_LIBDIR "${DEFAULT_ABI}")
		rcscripts_dir="/${libdir}/rcscripts"
	fi
	
	dodir /etc /usr/share/baselayout
	cp -pPR etc/* etc.Linux/* ${D}/etc/ || die
	cp -pPR share.Linux/* ${D}/usr/share/baselayout || die

	einfo "Creating directories..."

	keepdir /usr
	keepdir /usr/local
	keepdir /boot
	keepdir /etc/conf.d
	keepdir /etc/cron.daily
	keepdir /etc/cron.hourly
	keepdir /etc/cron.monthly
	keepdir /etc/cron.weekly
	keepdir /etc/env.d
	keepdir /etc/modules.autoload.d
	keepdir /etc/modules.d
	keepdir /etc/opt
	keepdir /etc/profile.d
	keepdir /etc/portage
	keepdir /home
	keepdir ${rcscripts_dir}
	keepdir /mnt
	keepdir /mnt/cdrom
	keepdir /mnt/floppy
	keepdir /opt
	keepdir /sbin
	keepdir /usr/bin
	keepdir /usr/include
	keepdir /usr/include/asm
	keepdir /usr/include/linux
	keepdir /usr/local/bin
	keepdir /usr/local/games
	keepdir /usr/local/sbin
	keepdir /usr/local/share
	keepdir /usr/local/share/doc

	keepdir /usr/local/share/man
	dosym /usr/share/man /usr/local/share/man

	keepdir /usr/local/src
	keepdir /usr/sbin
	keepdir /usr/share/doc
	keepdir /usr/share/info
	keepdir /usr/share/man
	keepdir /usr/share/misc
	keepdir /usr/src
	
	keepdir /var
	
	keepdir /var/adm
	keepdir /var/spool/lpd
	keepdir /var/spool/news
	keepdir /var/spool/uucp

	keepdir /var/db/pkg
	keepdir /var/empty
	keepdir /var/lib/misc
	keepdir /var/lock/subsys
	keepdir /var/log/news
	keepdir /var/run
	keepdir /var/spool
	keepdir /var/state

	diropts -m 1777
	keepdir /tmp /var/tmp

	diropts -o root -g uucp -m0775 /var/lock
	keepdir /var/lock

	diropts -m0700
	keepdir /root
	
	dodoc ChangeLog

	into /
	dosbin "${FILESDIR}/MAKEDEV"
	dosym ../../sbin/MAKEDEV /usr/sbin/MAKEDEV

	# The following code generates an /etc/env.d/04multilib file for
	# multilib profiles which contain default settings for all library
	# paths to search. Note that currently, "/lib", "/usr/lib" and
	# "/usr/local/lib" is on this list, which may not be necessary
	# is SYMLINK_LIB is set in the profile. If possible, this should
	# be tweaked/simplified:
	
	if has_multilib_profile || [ $(get_libdir) != "lib" -o -n "${CONF_MULTILIBDIR}" ]; then
		local libdirs="$(get_all_libdirs)" libdirs_env= dir=
		: ${libdirs:=lib}	# it isn't that we don't trust multilib.eclass...
		for dir in ${libdirs}; do
			libdirs_env=${libdirs_env:+$libdirs_env:}/${dir}:/usr/${dir}:/usr/local/${dir}
		done

		# Special-case uglyness... For people updating from lib32 -> lib amd64
		# profiles, keep lib32 in the search path while it's around
		if has_multilib_profile && [ -d "${ROOT}"lib32 -o -d "${ROOT}"lib32 ] && ! hasq lib32 ${libdirs}; then
			libdirs_env="${libdirs_env}:/lib32:/usr/lib32:/usr/local/lib32"
		fi
		echo "LDPATH=\"${libdirs_env}\"" > "${T}"/04multilib
		doenvd "${T}"/04multilib
	fi

	# rc-scripts version for testing of features that *should* be present
	echo "Funtoo Linux - baselayout ${PV}" > "${D}"/etc/gentoo-release
}

pkg_postinst() {

	# create some directories that will fail on merge due to .keep files. Once
	# Portage has deprecated .keep files, this stuff can be moved back to
	# src_install:

	local x

	for x in proc sys dev dev/pts dev/shm
	do
		install -d ${ROOT}${x}
	done

	# templates installed to /usr/share/baselayout and copied into place if they
	# don't exist in /etc.

	for x in master.passwd passwd shadow group fstab ; do
		[ -e "${ROOT}etc/${x}" ] && continue
		[ -e "${ROOT}usr/share/baselayout/${x}" ] || continue
		cp -p "${ROOT}usr/share/baselayout/${x}" "${ROOT}"etc
	done

	# carefully set perms for shadow to prevent non-root users from viewing
	# encrypted password files.
	
	for x in shadow ; do
		[ -e "${ROOT}etc/${x}" ] && chmod 0600 "${ROOT}etc/$x"
	done

	# create minimal set of device nodes required for boot, if they do not
	# already exist. The chmod commonds are also run every time to ensure that
	# proper permissions are set on the device nodes, even if they already
	# exist.

	# Below, we want to create a base set of device nodes that will be suitable
	# for chrooting, for OpenVZ, for emergency/initial booting without udev,
	# and for stage builds. Some ebuilds require urandom to exist.

	# But we are only going to perform these steps if we are not merging to /:

	[ "${ROOT}" = "/" ] && return 0
	
	# BEGINNING OF COMMANDS THAT ONLY RUN IF ROOT != /

	cd "${ROOT}"/dev || die

	[ -e console ] || mknod console c 5 1 || die
	chmod 600 console

	[ -e null ] || mknod null c 1 3 || die
	chmod 777 null

	[ -e tty ] || mknod tty c 5 0 || die
	chmod 666 tty

	[ -e ttyp0 ] || mknod ttyp0 c 3 0 || die
	chmod 644 ttyp0

	[ -e ptyp0 ] || mknod ptyp0 c 2 0 || die
	chmod 644 ptyp0

	[ -e ptmx ] || mknod ptmx c 5 2 || die
	chmod 666 ptmx

	[ -e tty0 ] || mknod tty0 c 4 0 || die
	chmod 666 tty0
	
	[ -e urandom ] || mknod urandom c 1 9 || die
	chmod 666 urandom

	[ -e random ] || mknod random c 1 8 || die
	chmod 666 random

	[ -e zero ] || mknod zero c 1 5 || die
	chmod 666 zero

	for x in 0 1 2 3
	do
		[ -e ttyS${x} ] || mknod ttyS${x} c 4 $(( 64 + $x )) || die
		chmod 600 ttyS${x}
	done

	# END OF COMMANDS THAT ONLY RUN IF ROOT != /
}
