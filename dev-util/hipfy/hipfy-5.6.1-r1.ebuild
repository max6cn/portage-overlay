# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Radeon Open Compute HIPIFY"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIPIFY"

KEYWORDS="~amd64"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIPIFY/archive/refs/tags/rocm-${PV}.tar.gz -> HIPIFY-${PV}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug test"
RESTRICT="!test? ( test )"

S=${WORKDIR}/HIPIFY-rocm-${PV}

RDEPEND="!<dev-util/hip-5.6"
PATCHES=(
	"${FILESDIR}/${PN}-5.6-fix-link.patch"
)
src_prepare() {
	# hardcoded paths are wrong

	CXX=hipcc cmake_src_prepare
	# message "Skipped"
}
src_configure() {


	export CC=clang
	export CXX=clang++
	local mycmakeargs=(
	  -DCMAKE_PREFIX_PATH="/usr/lib/llvm/16"
    #   -DLLVM_TARGETS_TO_BUILD="" 
    #   -DLLVM_ENABLE_PROJECTS="" 
      -DLLVM_INCLUDE_TESTS=OFF 
	  -DCMAKE_CXX_FLAGS="-stdlib=libc++"
      -DCMAKE_BUILD_TYPE=Release 
	)
	# LD_LIBRARY_PATH=/opt/conda3/lib HIP_CLANG_PATH=/opt/rocm/llvm/bin/ PATH=/opt/rocm/llvm/bin:/opt/rocm/bin:$PATH CXX=/opt/rocm/hip/bin/hipcc  cmake_src_configure
	

	cmake_src_configure

}