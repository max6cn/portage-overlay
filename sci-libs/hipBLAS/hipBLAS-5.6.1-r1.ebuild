# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm
DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-util/hip
	sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
	sci-libs/rocSOLVER:${SLOT}[${ROCM_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/hipBLAS-rocm-${PV}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENTS_TESTS=OFF  # currently hipBLAS is a wrapper of rocBLAS which has tests, so no need to perform test here
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
	)
	# LD_LIBRARY_PATH=/opt/conda3/lib HIP_CLANG_PATH=/opt/rocm/llvm/bin/ PATH=/opt/rocm/llvm/bin:/opt/rocm/bin:$PATH CXX=/opt/rocm/hip/bin/hipcc  cmake_src_configure
	# export LD_LIBRARY_PATH=/opt/rocm/lib:/opt/rocm/rccl/lib:/opt/conda3/lib 
	# export HIP_CLANG_PATH="/usr/lib/llvm/16/bin"
	# export CXX=hipcc
	export HIP_CLANG_PATH=/opt/rocm-5.6.0/llvm/bin
	export CXX=/opt/rocm-5.6.0/bin/hipcc	
	export HIP_PLATFORM="amd"
	export ROCM_PATH=/usr
	# export HIP_CLANG_PATH=/opt/rocm-5.6.0/llvm/bin
	# export CXX=/opt/rocm-5.6.0/bin/hipcc
	cmake_src_configure
}
