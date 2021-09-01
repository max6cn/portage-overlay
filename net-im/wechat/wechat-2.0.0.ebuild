# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
epoch=2
DESCRIPTION="A client to the Slack chat service."
HOMEPAGE="https://www.chinauos.com/resource/download-professional"
SRC_URI="https://cdn-package-store6.deepin.com/appstore/pool/appstore/c/com.qq.weixin/com.qq.weixin_${PV}-${epoch}_amd64.deb"

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
    x11-libs/libnotify
    x11-libs/libXtst
    dev-libs/nss
    dev-lang/python
    gnome-base/gvfs
    x11-misc/xdg-utils
    x11-misc/xssstate
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
    cp -R "opt" ${D}
    domenu ${FILESDIR}/wechat.desktop
    dobin  ${FILESDIR}/wechat
    insopts ${FILESDIR}/uos-release
    insopts ${FILESDIR}/uos-lsb
}

