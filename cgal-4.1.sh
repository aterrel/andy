#/bin/bash

PKG=CGAL
VERSION=4.1
DESCRIPTION="Efficient and reliable geometric algorithms in the form of a C++ library"
URL=http://www.cgal.org/
DOWNLOAD_URL=https://gforge.inria.fr/frs/download.php/31641/CGAL-4.1.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build

download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
module load gmp mpfr
pushd ${PKG_SRC_DIR}
echo_and_run cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_BUILD_TYP=Release \
      -DCMAKE_CXX_COMPILER=icpc \
      -DCMAKE_CXX_FLAGS="-mkl" \
      -DCMAKE_C_COMPILER=icc \
      -DCMAKE_C_FLAGS="-mkl" \
      -DGMP_INCLUDE_DIR=${GMP_DIR}/include \
      -DGMP_LIBRARIES=${GMP_DIR}/lib \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
echo_and_run make
echo_and_run make install
popd

# Write modulefile
echo_and_run mkdir -p `dirname ${MODULEFILE}`
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} : ${DESCRIPTION}

The following environment variable is added: ${PKG^^}_DIR

Updating LIBRARY_PATH, LD_LIBRARY_PATH, and CPLUS_INCLUDE_PATH environment variables.

Version ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

local pkg_bin = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")
local pkg_man = pathJoin(base, "share/man")
prepend_path("PATH", pkg_bin)
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)
prepend_path("C_INCLUDE_PATH", pkg_include)
prepend_path("MANPATH", pkg_man)

setenv("${PKG^^}_DIR", base)
EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build
