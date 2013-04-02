#!/bin/bash

set -e 

PKG=ufc
VERSION=2.2.0
DESCRIPTION="A unified framework for finite element assembly"
URL=http://fenicsproject.org
DOWNLOAD_URL=https://launchpad.net/ufc/2.2.x/2.2.0/+download/ufc-2.2.0.tar.gz

. install_scripts/incl.sh
PY_INSTALL_DIR=${INSTALL_DIR}/lib/python2.7/site-packages
BUILD_DIR=${PKG_SRC_DIR}/build

if_done_exit
start_build
download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
module load boost anaconda swig
pushd ${PKG_SRC_DIR}
echo_and_run cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_CXX_COMPILER=icpc \
      -DCMAKE_C_COMPILER=icc \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DBoost_INCLUDE_DIR=${BOOST_DIR}/include \
      -DPYTHON_EXECUTABLE=${ANACONDA_DIR}/bin/python \
      -DPYTHON_INCLUDE_PATH=${ANACONDA_DIR}/include/python2.7 \
      -DUFC_INSTALL_PYTHON_EXT_DIR=${PY_INSTALL_DIR} \
      -DUFC_INSTALL_PYTHON_MODULE_DIR=${PY_INSTALL_DIR}
echo_and_run make
echo_and_run make install
popd

# Write modulefile
echo_and_run mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} python library:

${DESCRIPTION}

It updates the PYTHONPATH, PATH, and MANPATH environment variable.

Requires python module be loaded.

Version: ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

prereq("python")

local pkg_path = pathJoin(base, "bin")
local pkg_man = pathJoin(base, "share/man")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")

prepend_path("PATH", pkg_path)
prepend_path("MANPATH", pkg_man)
prepend_path("PYTHONPATH", pkg_py)

EOF

echo_and_run rm -rf ${PKG_SRC_DIR}
finish_build