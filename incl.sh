#!/bin/bash

ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}
TARBALL=${SRC_DIR}/tarballs/${PKG}-${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/logs/${PKG}-${VERSION}.log
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

MKLROOT=/opt/apps/sysnet/intel/12.1/composer_xe_2011_sp1.7.256/mkl
MKL_LIB_DIR=${MKLROOT}/lib/intel64

MPI_DIR=/opt/apps/ossw/libraries/openmpi/openmpi-1.6/sl6/intel-12.1

. install_scripts/functions.sh
