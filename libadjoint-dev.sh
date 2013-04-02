#/bin/bash

set -e

PKG=libadjoint
VERSION=dev
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}
BUILD_DIR=${PKG_SRC_DIR}/build
#TARBALL=${SRC_DIR}/${PKG}-${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua
MKL_LIB_DIR=${MKLROOT}/lib/intel64

# Update development direcotry or download it
if [ -d ${PKG_SRC_DIR} ]; then
    pushd ${PKG_SRC_DIR}
    bzr revert
    bzr pull
    popd
else 
    pushd ${SRC_DIR}
    bzr branch lp:libadjoint
    popd
fi

# Configure and make
module purge
module purge
module load TACC fenics gccxml
pushd ${PKG_SRC_DIR}
export LD_LIBRARY_PATH=${SLEPC_DIR}/${PETSC_ARCH}/lib:$LD_LIBRARY_PATH
export CC=mpicxx
sed -i -e 's/-Wunsafe-loop-optimizations//' -e 's/-ggdb3//' -e 's/-lstdc++//' -e 's/-q build/build/' Makefile
make clean

patch -p0 << EOF
=== modified file 'python/setup.py'
--- python/setup.py	2012-03-22 11:52:59 +0000
+++ python/setup.py	2013-03-13 21:44:51 +0000
@@ -1,7 +1,8 @@
 from distutils.core import setup, Extension
 
 python_utils=Extension("libadjoint.python_utils",
-                       sources=["libadjoint/adj_python_utils.c"]
+                       sources=["libadjoint/adj_python_utils.c"],
+                       libraries=["stdc++"],
                        )
 
 setup (name = 'libadjoint',
EOF

rm -rf ${INSTALL_DIR}
make  2>&1 | tee -a ${LOGFILE}
make install prefix=${INSTALL_DIR} 2>&1 | tee -a ${LOGFILE}
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the libadjoint library for adjoining complex models.

Updating LIBRARY_PATH, LD_LIBRARY_PATH, CPLUS_INCLUDE_PATH, PATH, PYTHONPATH, PKG_CONFIG_PATH, and MANPATH environment variables.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"
local slepc_lib = "${SLEPC_DIR}/${PETSC_ARCH}/lib"

whatis("Description: libadjoint library")
whatis("URL: https://launchpad.net/libadjoint")

local pkg_path = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
local pkg_include = pathJoin(base, "include")
local pkg_man = pathJoin(base, "share/man")
local pkg_demo = pathJoin(base, "share/dolfin/demo")

prepend_path("PATH", pkg_path) 
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", slepc_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)
prepend_path("PYTHONPATH", pkg_py)
prepend_path("MANPATH", pkg_man)
EOF
