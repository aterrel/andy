#/bin/bash

PKG=bzr
VERSION=2.6b2
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}
TARBALL=${SRC_DIR}/${PKG}-${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULEFILE=${ROOT_DIR}/modulefiles/${PKG}/${VERSION}.lua

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
module load python elementtree
python setup.py install --prefix=${INSTALL_DIR} 2>&1 | tee ${LOGFILE}
popd

# Remove source
rm -rf ${PKG_SRC_DIR}

# Write modulefile
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the bazaar version control system. Updating path, manpath, and pythonpath environment variables.

Requires python and elementtree modulues be loaed.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: Bazaar version control system")
whatis("URL: http://bazaar.canonical.com/en/")

prereq("python", "elementtree")

local pkg_bin = pathJoin(base, "bin")
local pkg_man = pathJoin(base, "man")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
prepend_path("PATH", pkg_bin)
prepend_path("MANPATH", pkg_man)
prepend_path("PYTHONPATH", pkg_py)
EOF