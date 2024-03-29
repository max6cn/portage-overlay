# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
inherit xorg-3
# SRC_URI="mirror://example/${PN}/${P}.tar.gz"
SRC_URI="https://www.x.org/releases/individual/proto/printproto-1.0.5.tar.bz2"
DESCRIPTION="X.Org Print protocol headers"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
