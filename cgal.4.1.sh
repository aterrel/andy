#/bin/bash

PKG=CGAL
VERSION=4.1
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
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_BUILD_TYP=Release \
      -DCMAKE_CXX_COMPILER=${ICC_BIN}/icpc \
      -DCMAKE_CXX_FLAGS="-mkl" \
      -DCMAKE_C_COMPILER=${ICC_BIN}/icc \
      -DCMAKE_C_FLAGS="-mkl" \
      -DGMP_INCLUDE_DIR=${GMP_DIR}/include \
      -DGMP_LIBRARIES=${GMP_DIR}/lib \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      .. 2>&1 | tee ${LOGFILE}
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
This module loads the CGAL: Computational Geometry Algorithms Library

Updating PATH, LIBRARY_PATH, LD_LIBRARY_PATH, MANPATH, C_INCLUDE_PATH and CPLUS_INCLUDE_PATH environment variables. Setting CGAL_DIR
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: CGAL: Computational Geometry Algorithms Library")
whatis("URL: http://www.cgal.org/")

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

setenv("CGAL_DIR", base)
EOF