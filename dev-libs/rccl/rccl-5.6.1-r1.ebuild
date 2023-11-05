# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake edo rocm

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz -> rccl-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/5.6"
IUSE="test"

LLVM_MAX_SLOT=16

RDEPEND="dev-util/hip
dev-util/rocm-smi:${SLOT}"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/cmake-3.22
	>=dev-util/rocm-cmake-5.0.2-r1
	test? ( dev-cpp/gtest )"

RESTRICT="!test? ( test )"
S="${WORKDIR}/rccl-rocm-${PV}"

PATCHES=(
	# "${FILESDIR}/${PN}-5.7.1-change_install_location.patch"
	# "${FILESDIR}/${PN}-5.1.3-remove-chrpath.patch"
)

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DSKIP_RPATH=On
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TESTS=$(usex test ON OFF)
		# -DCMAKE_CXX_FLAGS="-isystem /usr/include  --rocm-path=/usr --hip-device-lib-path=/usr/lib/amdgcn/bitcode -D__HIP_PLATFORM_HCC__= -D__HIP_PLATFORM_AMD__= -I/usr/include "
		# -D__HIP_PLATFORM_HCC__="/opt/rocm/llvm/bin/clang++"
		# -D__HIP_PLATFORM_AMD__=""
		-Wno-dev
	)
	append-cxxflags "--rocm-path=/usr --hip-device-lib-path=/usr/lib/amdgcn/bitcode"
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


	/opt/rocm/bin/hipconfig
	cmake_src_configure

}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}" edob test/UnitTests
}
