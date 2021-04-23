# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/${PV}.tar.gz -> hipCUB-$(ver_cut 1-2).tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

#S="${WORKDIR}/hipCUB-rocm-$(ver_cut 1-2)"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*
         =sci-libs/rocPRIM-${PV}*"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_prepare() {
	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

        sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 2.8.19386 REQUIRED):" -i cmake/VerifyCompiler.cmake

	sed -e "s: PREFIX hipcub:# PREFIX hipcub:" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:  DESTINATION hipcub/include/:  DESTINATION include/:" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(hipcub):#rocm_install_symlink_subdir(hipcub):" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:<INSTALL_INTERFACE\:hipcub/include/:<INSTALL_INTERFACE\:include/hipcub/:" -i ${S}/hipcub/CMakeLists.txt

	sed -e "s:set(ROCM_INSTALL_LIBDIR lib:set(ROCM_INSTALL_LIBDIR \${CMAKE_INSTALL_LIBDIR}:" -i ${S}/cmake/ROCMExportTargetsHeaderOnly.cmake

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DBUILD_TEST=OFF
		-Drocprim_DIR=/usr
		-DCMAKE_INSTALL_PREFIX=/usr
	)

	cmake-utils_src_configure
}
