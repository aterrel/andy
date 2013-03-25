#/bin/bash

set -e

function echo_and_run { 
    echo "\$ $@" | tee -a $LOGFILE
    "$@" 2>&1 | tee -a $LOGFILE
    status=${PIPESTATUS[0]}
    if [ $status -ne 0 ]; then
        echo "error with $1"
    fi
    return $status
}

PKG=nautilus-dropbox
VERSION=1.4.0
URL=http://www.dropbox.com/
DESCRIPTION="A cloud file sharing tool"
DOWNLOAD_URL=https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-1.6.0-1.fedora.x86_64.rpm
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}
BUILD_DIR=${PKG_SRC_DIR}/build/release
TARBALL=${SRC_DIR}/nautilus-dropbox-1.6.0-1.fedora.x86_64.rpm
LOGFILE=${SRC_DIR}/logs/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

mkdir -p ${SRC_DIR}/logs
echo "Starting build: `date`" | tee ${LOGFILE}
# Remove previous source and unpack tarball
if [ ! -f ${TARBALL} ]; then
    echo_and_run wget  ${DOWNLOAD_URL}
fi
echo_and_run rm -rf ${PKG_SRC_DIR}

mkdir -p ${INSTALL_DIR} 
# Configure and make
pushd ${INSTALL_DIR}
echo_and_run rpm2cpio ${TARBALL} | cpio -idmv
popd

# Write modulefile
echo_and_run mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} : ${DESCRIPTION}
See ${URL}

Updating PATH environment variables. Setting DROPBOX_DIR
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${PKG}: ${DESCRIPTION}")
whatis("URL: ${URL}")

local pkg_bin = pathJoin(base, "usr/bin")
prepend_path("PATH", pkg_bin)
setenv("DROPBOX_DIR", base)
EOF

echo "Finishing build: `date`" | tee -a ${LOGFILE}
