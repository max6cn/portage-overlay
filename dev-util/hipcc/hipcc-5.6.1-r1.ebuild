# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Radeon Open Compute hipcc"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipcc"

KEYWORDS="~amd64"
SRC_URI="https://github.com/ROCm-Developer-Tools/hipcc/archive/refs/tags/rocm-${PV}.tar.gz -> hipcc-${PV}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug test"
RESTRICT="!test? ( test )"

S=${WORKDIR}/HIPCC-rocm-${PV}

RDEPEND="!<dev-util/hip-5.6"

src_prepare() {
	# hardcoded paths are wrong
	sed -i -e 's~$ROCM_PATH/llvm/bin~/usr/lib/llvm/16/bin~' bin/hipvars.pm || die
	sed -e "/FLAGS .= \" -isystem \$HSA_PATH/d" \
		-e "/HIP.*FLAGS.*isystem.*HIP_INCLUDE_PATH/d" \
		-e "s:\$ENV{'DEVICE_LIB_PATH'}:'${EPREFIX}/usr/lib/amdgcn/bitcode':" \
		-e "s:\$ENV{'HIP_LIB_PATH'}:'${EPREFIX}/usr/$(get_libdir)':" \
		-e "/rpath/s,--rpath=[^ ]*,," -i bin/hipcc.pl || die
	cmake_src_prepare
}
