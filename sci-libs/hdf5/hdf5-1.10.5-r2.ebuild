# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran
# EAPI=7 uses ninja generator by default but it's incompatible with USE=fortran
# https://github.com/Kitware/ninja/tree/features-for-fortran#readme
CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake-utils eutils fortran-2 flag-o-matic toolchain-funcs multilib prefix

MY_P=${PN}-${PV/_p/-patch}
MAJOR_P=${PN}-$(ver_cut 1-2)

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="http://www.hdfgroup.org/HDF5/"
SRC_URI="http://www.hdfgroup.org/ftp/HDF5/releases/${MAJOR_P}/${MY_P}/src/${MY_P}.tar.bz2"

LICENSE="NCSA-HDF"
SLOT="0/${PV%%_p*}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cxx debug examples fortran +hl mpi static-libs szip threads zlib"

REQUIRED_USE="
	cxx? ( !mpi ) mpi? ( !cxx )
	threads? ( !cxx !mpi !fortran !hl )"

RDEPEND="
	mpi? ( virtual/mpi[romio] )
	szip? ( virtual/szip )
	zlib? ( sys-libs/zlib:0= )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.9-static_libgfortran.patch
	"${FILESDIR}"/${PN}-1.8.9-mpicxx.patch
	"${FILESDIR}"/${PN}-1.8.13-no-messing-ldpath.patch
)

pkg_setup() {
	tc-export CXX CC AR # workaround for bug 285148
	use fortran && fortran-2_pkg_setup

	if use mpi; then
		if has_version 'sci-libs/hdf5[-mpi]'; then
			ewarn "Installing hdf5 with mpi enabled with a previous hdf5 with mpi disabled may fail."
			ewarn "Try to uninstall the current hdf5 prior to enabling mpi support."
		fi
		export CC=mpicc
		use fortran && export FC=mpif90
	elif has_version 'sci-libs/hdf5[mpi]'; then
		ewarn "Installing hdf5 with mpi disabled while having hdf5 installed with mpi enabled may fail."
		ewarn "Try to uninstall the current hdf5 prior to disabling mpi support."
	fi
}

src_prepare() {
	# respect gentoo examples directory
	sed \
		-e "s:hdf5_examples:doc/${PF}/examples:g" \
		-i $(find . -name Makefile.am) $(find . -name "run*.sh.in") || die
	sed \
		-e '/docdir/d' \
		-i config/commence.am || die
	if ! use examples; then
		sed -e '/^install:/ s/install-examples//' \
			-i Makefile.am || die #409091
	fi
	# omit package version in pkg-conf file names
	sed -i -e "s/\-\${HDF5_PACKAGE_VERSION}\.pc/\.pc/g" $(find -name CMakeLists.txt)
	# enable shared libs by default for h5cc config utility
	sed -i -e "s/SHLIB:-no/SHLIB:-yes/g" tools/src/misc/h5cc.in || die

	for cm in c++/src/CMakeLists.txt hl/c++/src/CMakeLists.txt hl/src/CMakeLists.txt src/CMakeLists.txt
	do
		# should be probably addressed by upstream.
		sed -i -e 's@_PKG_CONFIG_LIBDIR \\\${exec_prefix}/lib@_PKG_CONFIG_LIBDIR \\${prefix}/${HDF5_INSTALL_LIB_DIR}@' \
			"${cm}" || die "sed on ${cm} failed"
	done

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHDF5_INSTALL_LIB_DIR=$(get_libdir)
		-DHDF5_BUILD_CPP_LIB=$(usex cxx)
		-DHDF5_BUILD_EXAMPLES=$(usex examples)
		-DHDF5_BUILD_FORTRAN=$(usex fortran)
		-DHDF5_BUILD_HL_LIB=$(usex hl)
		-DHDF5_ENABLE_PARALLEL=$(usex mpi)
		-DHDF5_ENABLE_THREADSAFE=$(usex threads)
		-DHDF5_ENABLE_SZIP_SUPPORT=$(usex szip)
		-DHDF5_ENABLE_SZIP_ENCODING=$(usex szip)
		-DHDF5_ENABLE_Z_LIB_SUPPORT=$(usex zlib)
	)
	cmake-utils_src_configure
}
