#/bin/bash

set -e

PKG=anaconda
VERSION=1.4.0
URL=https://store.continuum.io/cshop/anaconda
DESCRIPTION="Python distribution for large-scale data processing"
DOWNLOAD_URL=http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.4.0-Linux-x86_64.sh
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
BUILD_DIR=${PKG_SRC_DIR}/build/release
TARBALL=${SRC_DIR}/tarball/Anaconda-${VERSION}-Linux-x86_64.sh
LOGFILE=${SRC_DIR}/logs/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

source ${SRC_DIR}/install_scripts/functions.sh

if_done_exit
start_build
mkdir -p ${SRC_DIR}/logs
# Remove previous source and unpack tarball
if [ ! -f ${TARBALL} ]; then
    echo_and_run wget ${DOWNLOAD_URL}
fi
echo_and_run rm -rf ${INSTALL_DIR}
printf "\nyes\n${INSTALL_DIR}\n" | bash Anaconda-1.4.0-Linux-x86_64.sh | tee -a ${LOGFILE}
test ${PIPESTATUS[0]}

# Write modulefile
echo_and_run mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} : ${DESCRIPTION}

Updating PATH environment variables. Setting ${PKG^^}_DIR
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${PKG}: ${DESCRIPTION}")
whatis("URL: ${URL}")

local pkg_bin = pathJoin(base, "bin")
prepend_path("PATH", pkg_bin)

setenv("${PKG^^}_DIR", base)
EOF

finish_build