#/bin/bash

PKG=armadillo
VERSION=3.6.1
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}
TARBALL=${SRC_DIR}/${PKG}-${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
MKL_LIB_DIR=${MKLROOT}/lib/intel64

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_CXX_COMPILER=${ICC_BIN}/icpc \
      -DCMAKE_CXX_FLAGS="-mkl" \
      -Dmkl_core_LIBRARY=${MKL_LIB_DIR}/libmkl_core.so \
      -Dmkl_intel_lp64_LIBRARY=${MKL_LIB_DIR}/libmkl_intel_lp64.so \
      -Dmkl_intel_thread_LIBRARY=${MKL_LIB_DIR}/libmkl_intel_thread.so \
      -Dmkl_lapack_LIBRARY=${MKL_LIB_DIR}/libmkl_lapack95_lp64.a \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      2>&1 | tee ${LOGFILE}
make  2>&1 | tee -a ${LOGFILE}
make install 2>&1 | tee -a ${LOGFILE}
popd

# Remove source
rm -rf ${PKG_SRC_DIR}

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the Armadillo C++ linear algbra library. Updating LIBRARY_PATH, LD_LIBRARY_PATH, and CPLUS_INCLUDE_PATH environment variables.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: Armadillo C++ linear algebra library")
whatis("URL: http://arma.sourceforge.net/")

local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)
EOF