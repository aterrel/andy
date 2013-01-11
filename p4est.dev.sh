#/bin/bash

PKG=p4est
VERSION=dev
BUILD=fclaw
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}/${BUILD}
PKG_SRC_DIR=${SRC_DIR}/${PKG}
BUILD_DIR=${PKG_SRC_DIR}/build/fclaw
#TARBALL=${PKG_SRC_DIR}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}-${BUILD}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
MKL_LIB_DIR=${MKLROOT}/lib/intel64

# Remove previous source and unpack tarball
if [ -d ${PKG_SRC_DIR} ]; then
    pushd ${PKG_SRC_DIR}
    git pull
    pushd sc
    git pull
    popd
    popd
else 
    git clone git://github.com/cburstedde/p4est.git
    pushd p4est
    git checkout -b fclaw remotes/origin/fclaw
    git clone git://github.com/cburstedde/libsc.git sc
    pushd sc
    git checkout -b cb/pu remotes/origin/cb/pu
    popd
    popd
fi

# Configure and make
pushd ${PKG_SRC_DIR}
./bootstrap 2>&1 | tee ${LOGFILE}
mkdir -p ${BUILD_DIR}
pushd  ${BUILD_DIR}
./../configure \
    CFLAGS=-mkl CC=icc FC=ifort \
    --prefix=$WORK/opt/apps/p4est/dev/fclaw \
    2>&1 | tee ${LOGFILE} 
make  2>&1 | tee -a ${LOGFILE}
make install 2>&1 | tee -a ${LOGFILE}
popd
popd

# Remove source
#rm -rf ${PKG_SRC_DIR}

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the p4est library. Updating PATH, LIBRARY_PATH, LD_LIBRARY_PATH, and C_INCLUDE_PATH environment variables. Adds P4EST_DIR.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: p4est: Parallel AMR on Forests of Octrees")
whatis("URL: http://www.p4est.org/")

local pkg_bin = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")

prepend_path("PATH", pkg_bin)
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("C_INCLUDE_PATH", pkg_include)
setenv("P4EST_DIR", base)
EOF