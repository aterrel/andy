#/bin/bash

set -e

PKG=petsc
VERSION=3.3-p6
DESCRIPTION="a suite of data structures and routines for the scalable (parallel) solution of scientific applications modeled by partial differential equations"
URL=http://mcs.anl.gov/petsc/index.html
DOWNLOAD_URL=http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.3-p6.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build

download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run ./configure \
    --prefix=${INSTALL_DIR} \
    --with-clanguage=CXX \
    --with-c-support=1 \
    --with-mpi-dir=${MPI_DIR} \
    --with-blas-lapack-dir=${MKLROOT} \
    --with-shared-libraries=1 

echo_and_run make all test install
popd

# Write modulefile
echo_and_run mkdir -p `dirname ${MODULEFILE}`
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} : ${DESCRIPTION}

The following environment variable is added: ${PKG^^}_DIR

Updating LIBRARY_PATH, LD_LIBRARY_PATH, and CPLUS_INCLUDE_PATH environment variables.

Version ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)

setenv("${PKG^^}_DIR", base)
EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build