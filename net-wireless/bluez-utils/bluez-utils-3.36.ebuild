# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-utils/bluez-utils-3.36.ebuild,v 1.14 2009/11/21 15:22:26 armin76 Exp $

inherit autotools multilib eutils

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://bluez.sourceforge.net/"
SRC_URI="http://bluez.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"

IUSE="alsa cups debug examples gstreamer old-daemons test-programs usb"

RDEPEND="
	>=net-wireless/bluez-libs-${PV}
	!net-wireless/bluez
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10 )
	usb? ( dev-libs/libusb )
	cups? ( net-print/cups )
	sys-fs/udev
	dev-libs/glib
	sys-apps/dbus"

DEPEND="
	!<dev-libs/libnl-1.1
	sys-devel/flex
	dev-util/pkgconfig
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	# bundled glib
	cd "${S}"
	rm -r eglib/{*.c,*.h}  || die
	if use cups; then
		epatch "${FILESDIR}/3.11/cups-location.patch"
		eautoreconf
	fi
}

src_compile() {
	# the order is the same as ./configure --help

	# we don't need the other daemons either with the new
	# service architechture

	econf \
		--enable-glib \
		--enable-network \
		--enable-serial \
		--enable-input \
		--enable-audio \
		$(use_enable gstreamer) \
		$(use_enable alsa) \
		$(use_enable usb) \
		--enable-netlink \
		--enable-tools \
		--enable-bccmd \
		--enable-hid2hci \
		--enable-dfutool \
		$(use_enable old-daemons hidd) \
		$(use_enable old-daemons pand) \
		$(use_enable old-daemons dund) \
		$(use_enable cups) \
		$(use_enable test-programs test) \
		--enable-manpages \
		--enable-configfiles \
		--disable-initscripts \
		--disable-pcmciarules \
		$(use_enable debug) \
		--localstatedir=/var

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog README || die

	if use test-programs ; then
		dobin input/test-input || die

		# a very simple example daemon
		dobin test/passkey-agent || die
		dobin test/auth-agent || die
	fi

	newinitd "${FILESDIR}/3.11/bluetooth-init.d" bluetooth || die
	newconfd "${FILESDIR}/3.11/bluetooth-conf.d" bluetooth || die

	if use old-daemons; then
		newconfd "${FILESDIR}/3.11/conf.d-hidd" hidd || die
		newinitd "${FILESDIR}/3.11/init.d-hidd" hidd || die
	fi

	# bug #84431
	insinto /etc/udev/rules.d/
	newins "${FILESDIR}/${PN}-3.10.1-udev.rules" 70-bluetooth.rules || die
	newins "${S}/scripts/bluetooth.rules" 70-bluetooth-pcmcia.rules || die

	exeinto /$(get_libdir)/udev/
	newexe "${FILESDIR}/${PN}-3.10.1-udev.script" bluetooth.sh || die
	doexe  "${S}/scripts/bluetooth_serial" || die

	insinto /etc/bluetooth
	doins \
		input/input.conf \
		audio/audio.conf \
		network/network.conf
}

pkg_postinst() {
	udevadm control --reload_rules && udevadm trigger

	elog
	elog "To use dial up networking you must install net-dialup/ppp."
	elog ""
	elog "Since 3.0 bluez has changed the passkey handling to use a dbus based"
	elog "API so please remember to update your /etc/bluetooth/hcid.conf."
	elog "For a password agent, there is for example net-wireless/bluez-gnome"
	elog "for gnome and net-wireless/kdebluetooth for kde."
	elog ""
	elog "Since 3.10.1 we don't install the old style daemons any more but rely"
	elog "on the new service architechture:"
	elog "	http://wiki.bluez.org/wiki/Services"
	elog ""
	elog "3.15 adds support for the audio service. See"
	elog "http://wiki.bluez.org/wiki/HOWTO/AudioDevices for configuration help."
	elog ""
	elog "Use the old-daemons use flag to get the old daemons like hidd"
	elog "installed. Please note that the init script doesn't stop the old"
	elog "daemons after you update it so it's recommended to run:"
	elog "  /etc/init.d/bluetooth stop"
	elog "before updating your configuration files or you can manually kill"
	elog "the extra daemons you previously enabled in /etc/conf.d/bluetooth."
	elog ""
	elog "If you want to use rfcomm as a normal user, you need to add the user"
	elog "to the uucp group."
	elog ""
	if use old-daemons; then
		elog "The hidd init script was installed because you have the old-daemons"
		elog "use flag on. It is not started by default via udev so please add it"
		elog "to the required runleves using rc-update <runlevel> add hidd. If"
		elog "you need init scripts for the other daemons, please file requests"
		elog "to https://bugs.gentoo.org."
	else
		elog "The bluetooth service should be started automatically by udev"
		elog "when the required hardware is inserted next time."
	fi
	elog
	ewarn "On first install you need to run /etc/init.d/dbus reload or hcid"
	ewarn "will fail to start."
}
