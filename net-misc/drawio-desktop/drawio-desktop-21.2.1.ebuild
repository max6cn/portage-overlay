# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit   xdg-utils

DESCRIPTION="Online diagramming web application"
HOMEPAGE="https://github.com/jgraph/drawio-desktop"
# https://github.com/jgraph/drawio-desktop/releases/download/v14.9.6/drawio-x86_64-14.9.6.rpm
# https://github.com/jgraph/drawio-desktop/releases/download/v14.9.6/drawio-x86_64-14.9.6.deb
SRC_URI="https://github.com/jgraph/${PN}/releases/download/v${PV}/drawio-amd64-${PV}.deb -> ${P}.deb"

LICENSE="Apache-2.0"
RESTRICT="strip"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
    >=sys-libs/glibc-2.29
"
RDEPEND="${DEPEND}"
BDEPEND=""

# S="${WORKDIR}/${MY_PN}-${PV}"
src_unpack() {
	if [ "${A}" != "" ]; then
        unpack ${A}
        unpack "${WORKDIR}/data.tar.xz"
    fi

    mkdir -p "${S}"
    cp -r "${WORKDIR}"/usr "${S}"/
	cp -r "${WORKDIR}"/opt "${S}"/

}

src_install() {
    cp -pPR "${WORKDIR}"/"${P}"/usr/ "${D}"/ || die "Installation failed"
	cp -pPR "${WORKDIR}"/"${P}"/opt/ "${D}"/ || die "Installation failed"

    # mv "${D}"/usr/lib "${D}"/usr/lib64
    # rm -Rf "${D}"/usr/lib64/.build-id
    # gunzip "${D}"/usr/share/man/man1/insync.1.gz

    # echo "SEARCH_DIRS_MASK=\"/usr/lib*/insync\"" > "${T}/70-${PN}" || die

    # insinto "/etc/revdep-rebuild" && doins "${T}/70-${PN}" || die
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
