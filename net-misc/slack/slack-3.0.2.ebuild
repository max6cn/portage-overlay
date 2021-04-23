# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A client to the Slack chat service."
HOMEPAGE="https://slack.com/"
SRC_URI="https://downloads.slack-edge.com/linux_releases/slack-desktop-${PV}-amd64.deb"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}

DEPEND=""
RDEPEND="${DEPEND}
    gnome-base/gconf:2
    x11-libs/gtk+:2
    virtual/libudev
    dev-libs/libgcrypt:11
    x11-libs/libnotify
    x11-libs/libXtst
    dev-libs/nss
    dev-lang/python
    gnome-base/gvfs
    x11-misc/xdg-utils
    x11-misc/xssstate
    gnome-base/libgnome-keyring
    gnome-base/gnome-keyring
    dev-libs/libappindicator
"

src_unpack() {
    if [ "${A}" != "" ]; then
        unpack ${A}
        unpack "${WORKDIR}/data.tar.xz"
    fi
}

src_install() {
    cp -R "etc" ${D}
    cp -R "usr" ${D}

}

