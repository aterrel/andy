#/bin/bash

set -e

PKG=icu
VERSION=4c-51.1.1
DESCRIPTION="A mature, widely used set of C/C++ and Java libraries providing Unicode and Globalization support for software applications."
URL=http://icu-project.org/
DOWNLOAD_URL=http://download.icu-project.org/files/icu4c/51.1/icu4c-51_1-src.tgz

ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}/source
TARBALL=${SRC_DIR}/icu4c-51_1-src.tgz
LOGFILE=${SRC_DIR}/logs/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
ICU_MODE=Linux

source ${SRC_DIR}/install_scripts/functions.sh

if_done_exit
start_build

if [ ! -f ${TARBALL} ]; then
    echo_and_run wget ${DOWNLOAD_URL}
fi

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run ./runConfigureICU ${ICU_MODE} --prefix=${INSTALL_DIR} 2>&1
echo_and_run make  2>&1
echo_and_run make install 2>&1
popd

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

# Write modulefile
echo_and_run mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} : ${DESCRIPTION}

Updating PATH, LIBRARY_PATH, LD_LIBRARY_PATH, C_INCLUDE_PATH, CPLUS_INCLUDE_PATH, and MANPATH environment variables.

Setting ${PKG^^}_DIR
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${PKG}: ${DESCRIPTION}")
whatis("URL: ${URL}")

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

setenv("${PKG^^}_DIR", base)
EOF

finish_build