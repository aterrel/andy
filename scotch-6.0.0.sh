#/bin/bash

set -e

PKG=scotch
VERSION=6.0.0
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}_${VERSION}
BUILD_DIR=${PKG_SRC_DIR}/src
TARBALL=${SRC_DIR}/${PKG}_${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}_${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
MKL_LIB_DIR=${MKLROOT}/lib/intel64

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}
ln -s Make.inc/Makefile.inc.x86-64_pc_linux2.icc Makefile.inc
sed -i -e 's/icc/mpicc/' -e 's/mpmpicc/mpicc/' -e 's/-DSCOTCH_PTHREAD/-fPIC/' Makefile.inc
make scotch ptscotch 2>&1 | tee ${LOGFILE}
mkdir -p ${INSTALL_DIR}
cp -r ${PKG_SRC_DIR}/* ${INSTALL_DIR}
popd

# Remove source
rm -rf ${PKG_SRC_DIR}

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the SCOTCH.

Updating PATH, LIBRARY_PATH, LD_LIBRARY_PATH, MANPATH, C_INCLUDE_PATH and CPLUS_INCLUDE_PATH environment variables. Setting SCOTCH_DIR
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: SCOTCH: graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering")
whatis("URL: http://scotch.gforge.inria.fr/")

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

setenv("SCOTCH_DIR", base)
EOF