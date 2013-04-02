#/bin/bash

set -e

PKG=dolfin
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
    bzr pull
    popd
else 
    bzr branch lp:dolfin
fi

# Configure and make
module purge
module purge
module load TACC fenics
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}
export CPLUS_INCLUDE_PATH=$TACC_HDF5_INC:$CPLUS_INCLUDE_PATH
export LIBRARY_PATH=$TACC_HDF5_LIB:$LIBRARY_PATH  
export LD_LIBRARY_PATH=$TACC_HDF5_LIB:$LD_LIBRARY_PATH
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_COMPILER=mpicxx \
      -DCMAKE_CXX_FLAGS="-mkl" \
      -DCMAKE_C_COMPILER=mpicc \
      -DCMAKE_C_FLAGS="-mkl" \
      -DCMAKE_FORTRAN_COMPILER=mpif90 \
      -DCMAKE_FORTRAN_FLAGS="-mkl" \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DARMADILLO_INCLUDE_DIRS=${ARMADILLO_DIR}/include \
      -DARMADILLO_LIBRARIES=${ARMADILLO_DIR}/lib/libarmadillo.so \
      -DHDF5_DIR=${TACC_HDF5_DIR} \
      -DHDF5_LIBRARIES=${TACC_HDF5_LIB}/libphdf5.so \
      -DPARMETIS_INCLUDE_DIRS=${PETSC_DIR}/externalpackages/parmetis-4.0.2-p3/${PETSC_ARCH}/include \
      -DPARMETIS_LIBRARY=${PETSC_DIR}/externalpackages/parmetis-4.0.2-p3/${PETSC_ARCH}/libparmetis/libparmetis.so \
      -DMETIS_LIBRARY=${PETSC_DIR}/externalpackages/metis-5.0.2-p3/${PETSC_ARCH}/libmetis/libmetis.so \
      -DPYTHON_INCLUDE_DIR=${TACC_PYTHON_DIR}/include/python2.7/ \
      -DPYTHON_LIBRARY=${TACC_PYTHON_LIB}/libpython2.7.so \
      -DPETSC_DIR=${PETSC_DIR} \
      -DPETSC_ARCH=${PETSC_ARCH} \
      -DSCOTCH_INCLUDE_DIRS=${SCOTCH_DIR}/include \
      -DSCOTCH_LIBRARY=${SCOTCH_DIR}/lib/libscotch.a \
      -DSCOTCH_DIR=${SCOTCH_DIR} \
      -DSLEPC_DIR=${SLEPC_DIR} \
      -DSLEPC_INCLUDE_DIRS=${SLEPC_DIR}/${PETSC_ARCH}/include \
      -DSLEPC_LIBRARY=${TACC_SLEPC_DIR}/${PETSC_ARCH}/lib/libslepc.so \
      -DZLIB_LIBRARY=/usr/lib64/libz.so \
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
This module loads the DOLFIN Problem Solving Environment for solving ODE's and PDE's. 

Updating LIBRARY_PATH, LD_LIBRARY_PATH, CPLUS_INCLUDE_PATH, PATH, PYTHONPATH, PKG_CONFIG_PATH, and MANPATH environment variables.

It also sets the DOLFIN_DIR and DOLFIN_DEMO environment variables.
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: DOLFIN library")
whatis("URL: https://launchpad.net/dolfin")

local pkg_path = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
local pkg_include = pathJoin(base, "include")
local pkg_man = pathJoin(base, "share/man")
local pkg_demo = pathJoin(base, "share/dolfin/demo")

prepend_path("PATH", pkg_path) 
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)
prepend_path("PYTHONPATH", pkg_py)
prepend_path("MANPATH", pkg_man)

setenv("DOLFIN_DIR", base)
setenv("DOLFIN_DEMO", pkg_demo)
EOF