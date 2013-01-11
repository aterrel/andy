#/bin/bash

PKG=ScientificPython
VERSION=2.9.2
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}
TARBALL=${SRC_DIR}/${PKG}-${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
module load python
python setup.py install --prefix=${INSTALL_DIR} 2>&1 | tee ${LOGFILE}
popd

# Remove source
rm -rf ${PKG_SRC_DIR}

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ScientificPython python library
It updates the PYTHONPATH environment variable.

Requires python module be loaded.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ScientificPython python library")
whatis("URL: http://dirac.cnrs-orleans.fr/plone/software/scientificpython/")

prereq("python")

local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
prepend_path("PYTHONPATH", pkg_py)
EOF