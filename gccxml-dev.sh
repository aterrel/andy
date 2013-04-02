#/bin/bash

set -e

PKG=gccxml
VERSION=dev
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}
BUILD_DIR=${PKG_SRC_DIR}/build
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
MKL_LIB_DIR=${MKLROOT}/lib/intel64

# Update development direcotry or download it
if [ -d ${PKG_SRC_DIR} ]; then
    pushd ${PKG_SRC_DIR}
    git pull
    popd
else 
    pushd ${SRC_DIR}
    git clone git://github.com/gccxml/gccxml.git
    popd
fi

# Configure and make
module purge
module purge
module load TACC fenics
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}
export CPLUS_INCLUDE_PATH=$TACC_HDF5_INC:$CPLUS_INCLUDE_PATH
export LIBRARY_PATH=$TACC_HDF5_LIB:$LIBRARY_PATH  
export LD_LIBRARY_PATH=$TACC_HDF5_LIB:$LD_LIBRARY_PATH
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      .. 2>&1 | tee ${LOGFILE}
make  2>&1 | tee -a ${LOGFILE}
make install 2>&1 | tee -a ${LOGFILE}
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the gccxml tool for XML output from gcc.

Updating LIBRARY_PATH, LD_LIBRARY_PATH, CPLUS_INCLUDE_PATH, PATH, PYTHONPATH, PKG_CONFIG_PATH, and MANPATH environment variables.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: gccxml")
whatis("URL: http://www.gccxml.org/HTML/Index.html")

local pkg_path = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
local pkg_include = pathJoin(base, "include")
local pkg_man = pathJoin(base, "share/man")
local pkg_demo = pathJoin(base, "share/dolfin/demo")

prepend_path("PATH", pkg_path) 
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)
prepend_path("PYTHONPATH", pkg_py)
prepend_path("MANPATH", pkg_man)
EOF
