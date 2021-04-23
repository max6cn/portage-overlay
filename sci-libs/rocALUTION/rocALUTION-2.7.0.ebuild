#

EAPI=7

inherit cmake-utils

DESCRIPTION="Sparse linear algebra library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-$(ver_cut 1-2).tar.gz -> rocALUTION-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+hip +openmp mpi"

RDEPEND="hip? ( =dev-util/hip-$(ver_cut 1-2)* )
	 hip? ( =sci-libs/rocSPARSE-$(ver_cut 1-2)* )
	 hip? ( =sci-libs/rocBLAS-$(ver_cut 1-2)* )
	 mpi? ( virtual/mpi )
	 openmp? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND}
	dev-util/cmake"

CMAKE_BUILD_TYPE="RelWithDebInfo"

S="${WORKDIR}/${PN}-rocm-$(ver_cut 1-2)"

src_prepare() {

	sed -e "s:/opt/rocm/hip/cmake:/usr/lib/hip/cmake:" -i ${S}/CMakeLists.txt
	sed -e "s:PREFIX rocalution:#PREFIX rocalution:" -i ${S}/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocalution):#rocm_install_symlink_subdir(rocalution):" -i ${S}/src/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {

	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/hcc/
	export HIP_IGNORE_HCC_VERSION=1

	local mycmakeargs=(
		-DSUPPORT_OMP=$(usex openmp ON OFF)
		-DSUPPORT_HIP=$(usex hip ON OFF)
		-DSUPPORT_MPI=$(usex mpi ON OFF)
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocALUTION"
	)
	cmake-utils_src_configure
}
