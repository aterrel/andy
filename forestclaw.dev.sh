#/bin/bash

PKG=forestclaw
VERSION=dev
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
PKG_SRC_DIR=${SRC_DIR}/${PKG}
BUILD_DIR=${PKG_SRC_DIR}/src
#TARBALL=${PKG_SRC_DIR}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

# Remove previous source and unpack tarball
if [ -d ${PKG_SRC_DIR} ]; then
    pushd ${PKG_SRC_DIR}
    git pull
else 
    git clone git@bitbucket.org:donnaaboise/forestclaw.git
fi

# Configure and make
module load p4est
export FORESTCLAW=${PKG_SRC_DIR}
export P4EST_CXX=icpc 
pushd ${BUILD_DIR}
make  2>&1 | tee ${LOGFILE}
#make install 2>&1 | tee -a ${LOGFILE}
popd

# Remove source
#rm -rf ${PKG_SRC_DIR}

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the forestclaw library. Updating LIBRARY_PATH, LD_LIBRARY_PATH, and CPP_INCLUDE_PATH environment variables. Adds P4EST_CXX and FORESTCLAW.
]])     

local version = "${VERSION}"
local base    = "${PKG_SRC_DIR}"

whatis("Description: forestclaw: p4est + clawpack")
whatis("URL: http://www.forestclaw.org/")

local pkg_lib = pathJoin(base, "src")
local pkg_include = pathJoin(base, "src")

prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("C_INCLUDE_PATH", pkg_include)

setenv("P4EST_CXX", "icpc")
setenv("FORESTCLAW", base)
EOF