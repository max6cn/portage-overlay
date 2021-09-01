# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm xdg-utils

DESCRIPTION="Webex by CISO, Calling, meetings, messaging, and events in the cloud for teams of all sizes."
HOMEPAGE="https://www.webex.com/"

SRC_URI="https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm"

RESTRICT="strip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
    >=sys-libs/glibc-2.29
"
RDEPEND="${DEPEND}"
BDEPEND=""

#PATCHES=(
#    "${FILESDIR}/insync-3-fix-ca-path.patch"
#    "${FILESDIR}/insync-3-lib64.patch"
#)

src_unpack() {
    rpm_src_unpack

}

src_install() {

	cp -R "opt" ${D}
    domenu ${FILESDIR}/webex.desktop

}

pkg_postinst() {
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
    xdg_icon_cache_update
}

pkg_postrm() {
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
    xdg_icon_cache_update
}
