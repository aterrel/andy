#/bin/bash

set -e

PKG=armadillo
VERSION=3.800.2
DESCRIPTION="Armadillo C++ linear algebra library"
URL=http://arma.sourceforge.net
DOWNLOAD_URL=http://sourceforge.net/projects/arma/files/armadillo-3.800.2.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build

download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_CXX_COMPILER=icpc \
      -DCMAKE_CXX_FLAGS="-mkl=sequential" \
      -Dmkl_core_LIBRARY=${MKL_LIB_DIR}/libmkl_core.so \
      -Dmkl_intel_lp64_LIBRARY=${MKL_LIB_DIR}/libmkl_intel_lp64.so \
      -Dmkl_intel_thread_LIBRARY=${MKL_LIB_DIR}/libmkl_intel_thread.so \
      -Dmkl_lapack_LIBRARY=${MKL_LIB_DIR}/libmkl_lapack95_lp64.a \
      -DCMAKE_VERBOSE_MAKEFILE=ON 
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

local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)

setenv("${PKG^^}_DIR", base)
EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build