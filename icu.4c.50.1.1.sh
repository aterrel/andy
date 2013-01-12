#/bin/bash

PKG=icu
VERSION=4c-50.1.1
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}/source
TARBALL=${SRC_DIR}/icu4c-50_1_1-src.tgz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
ICU_MODE=Linux

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
./runConfigureICU ${ICU_MODE} --prefix=${INSTALL_DIR} 2>&1 | tee ${LOGFILE}
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
This module loads the ICU library. 

Updating PATH, LIBRARY_PATH, LD_LIBRARY_PATH, C_INCLUDE_PATH, CPLUS_INCLUDE_PATH, and MANPATH environment variables.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ICU - International Components fr Unicode library")
whatis("URL: http://site.icu-project.org/")

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

setenv("ICU_DIR", base)
EOF