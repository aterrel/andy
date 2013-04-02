#/bin/bash

PKG=instant
VERSION=dev
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

# Update development direcotry or download it
if [ -d ${PKG_SRC_DIR} ]; then
    pushd ${PKG_SRC_DIR}
    bzr pull
    popd
else 
    bzr branch lp:${PKG}
fi

# Configure and make
pushd ${PKG_SRC_DIR}
module load python
python setup.py install --prefix=${INSTALL_DIR} 2>&1 | tee ${LOGFILE}
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads Instant,  Python module that allows for instant inlining of
C and C++ code

It updates the PYTHONPATH, PATH, and MANPATH environment variable.

Requires python module be loaded.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: Instant: a Python module that allows for instant inlining of C and C++ code")
whatis("URL: https://launchpad.net/instant")

prereq("python")

local pkg_path = pathJoin(base, "bin")
local pkg_man = pathJoin(base, "share/man")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")

prepend_path("PATH", pkg_path)
prepend_path("MANPATH", pkg_man)
prepend_path("PYTHONPATH", pkg_py)

EOF