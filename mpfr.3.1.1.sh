#/bin/bash

PKG=mpfr
VERSION=3.1.1
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}
BUILD_DIR=${PKG_SRC_DIR}/build
TARBALL=${SRC_DIR}/${PKG}-${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
MKL_LIB_DIR=${MKLROOT}/lib/intel64

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}
../configure --prefix=${INSTALL_DIR} \
      CXX=${ICC_BIN}/icpc \
      CXX_FLAGS="-mkl" \
      CC=${ICC_BIN}/icc \
      C_FLAGS="-mkl" \
      --enable-cxx \
      2>&1 | tee ${LOGFILE}
make  2>&1 | tee -a ${LOGFILE}
#make check 2>&1 | tee -a ${LOGFILE}
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
This module loads the MPFR library.

Updating LIBRARY_PATH, LD_LIBRARY_PATH, and CPLUS_INCLUDE_PATH environment variables. Sets MPFR_DIR environment variable.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: The GNU MPFR Library")
whatis("URL: http://mpfr.org/")

local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)
prepend_path("C_INCLUDE_PATH", pkg_include)

setenv("MPFR_DIR", base)
EOF