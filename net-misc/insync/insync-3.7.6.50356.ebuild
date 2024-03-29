
# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm xdg-utils

DESCRIPTION="Advanced cross-platform Google Drive and Microsoft OneDrive client"
HOMEPAGE="https://www.insynchq.com/"

SRC_URI="https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.7.6.50356-focal_amd64.deb"

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

PATCHES=(
    "${FILESDIR}/insync-3-fix-ca-path.patch"
    "${FILESDIR}/insync-3-lib64.patch"
)

src_unpack() {
	if [ "${A}" != "" ]; then
        unpack ${A}
        unpack "${WORKDIR}/data.tar.gz"
    fi

    mkdir -p "${S}"
    mv "${WORKDIR}"/usr "${S}"/
}

src_install() {
    cp -pPR "${WORKDIR}"/"${P}"/usr/ "${D}"/ || die "Installation failed"
    mv "${D}"/usr/lib "${D}"/usr/lib64
    rm -Rf "${D}"/usr/lib64/.build-id
    gunzip "${D}"/usr/share/man/man1/insync.1.gz

    echo "SEARCH_DIRS_MASK=\"/usr/lib*/insync\"" > "${T}/70-${PN}" || die

    insinto "/etc/revdep-rebuild" && doins "${T}/70-${PN}" || die
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
