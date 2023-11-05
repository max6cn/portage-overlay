EAPI=7

DESCRIPTION="Mozilla VPN"
HOMEPAGE="https://github.com/mozilla-mobile/mozilla-vpn-client/"
SRC_URI="https://github.com/mozilla-mobile/mozilla-vpn-client/archive/refs/tags/v$PV.zip"

LICENSE="MPL-2.0 MIT LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# FIXME: Gentoo splits Qt into multiple packages.  qtcore may be
# insufficient for this package.
#
# FIXME: Upstream requests `libpolkit-gobject-1-dev >=0.105`.  Find what
# this means, and add a package dependency for it.
#
# FIXME: Upstream requests `wireguard >=1.0.20200513`.  Find what this
# means, and add a package dependency for it.
#
# FIXME: upstream requests Python3 "glean_parser".  Find what this
# means.
#
# FIXME: upstream requests Python3 "pyhumps".  Find what this means.
DEPEND=">=dev-qt/qtcore-5.15.0
	net-vpn/wireguard-tools
	virtual/resolvconf
	dev-python/pyyaml
	dev-qt/qtwebsockets
	dev-qt/qtcharts
	dev-qt/qtnetworkauth"
RDEPEND="${DEPEND}"
BDEPEND=""

# FIXME: Upstream says to `git submodule init`.  Why?  Are they bundling
# other projects, and assuming those bundles will be checked out by the
# submodule?  If so, what needs to be done to tell the build system to
# use the system versions instead?

src_compile() {
	# glean
	python3 ./scripts/generate_glean.py
	# translations
	python3	./scripts/importLanguages.py
	qmake CONFIG+=production
	emake
}

# default src_install is probably fine
