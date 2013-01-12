#/bin/bash

PKG=ufc
VERSION=dev
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PY_INSTALL_DIR=${INSTALL_DIR}/lib/python2.7/site-packages
PKG_SRC_DIR=${SRC_DIR}/${PKG}
BUILD_DIR=${PKG_SRC_DIR}/build
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

# Update development direcotry or download it
# if [ -d ${PKG_SRC_DIR} ]; then
#     pushd ${PKG_SRC_DIR}
#     bzr pull
#     popd
# else 
#     bzr branch lp:${PKG}
# fi

# Configure and make
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}
echo "cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_CXX_COMPILER=${ICC_BIN}/icpc \
      -DCMAKE_C_COMPILER=${ICC_BIN}/icc \
      -DCMAKE_BUILD_TYPE=Release \
      -DUFC_INSTALL_PYTHON_EXT_DIR= ${PY_INSTALL_DIR} \
      -DUFC_INSTALL_PYTHON_MODULE_DIR= ${PY_INSTALL_DIR} \      
      .." 2>&1 | tee ${LOGFILE}

cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_CXX_COMPILER=${ICC_BIN}/icpc \
      -DCMAKE_C_COMPILER=${ICC_BIN}/icc \
      -DCMAKE_BUILD_TYPE=Release \
      -DPYTHON_EXECUTABLE=${TACC_PYTHON_DIR}/bin/python \
      -DUFC_INSTALL_PYTHON_EXT_DIR=${PY_INSTALL_DIR} \
      -DUFC_INSTALL_PYTHON_MODULE_DIR=${PY_INSTALL_DIR} \
      .. 2>&1 | tee ${LOGFILE}
make  2>&1 | tee -a ${LOGFILE}
make install 2>&1 | tee -a ${LOGFILE}
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the UFC python library
It updates the PYTHONPATH, PATH, and MANPATH environment variable.

Requires python module be loaded.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: UFC python library")
whatis("URL: https://launchpad.net/ufc")

prereq("python")

local pkg_path = pathJoin(base, "bin")
local pkg_man = pathJoin(base, "share/man")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")

prepend_path("PATH", pkg_path)
prepend_path("MANPATH", pkg_man)
prepend_path("PYTHONPATH", pkg_py)

EOF