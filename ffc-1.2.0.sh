#/bin/bash

PKG=ffc
VERSION=1.2.0
DESCRIPTION="a compiler for multilinear forms by generating code (C++) for the evaluation of a multilinear form given in mathematical notation"
URL=http://fenicsproject.org/
DOWNLOAD_URL=https://launchpad.net/ffc/1.2.x/1.2.0/+download/ffc-1.2.0.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build
download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
module load anaconda ScientificPython ufc swig fiat
echo_and_run python setup.py install --prefix=${INSTALL_DIR}
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} python library

${DESCRIPTION}

It updates the PYTHONPATH environment variable.

Requires a python module be loaded.

Version: ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

prereq("python", "fiat", "ufl")

local pkg_path = pathJoin(base, "bin")
local pkg_man = pathJoin(base, "share/man")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")

prepend_path("PATH", pkg_path)
prepend_path("MANPATH", pkg_man)
prepend_path("PYTHONPATH", pkg_py)
EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build