#/bin/bash

set -e

PKG=gmp
VERSION=5.1.1
DESCRIPTION="Library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers."
URL=http://gmplib.org
DOWNLOAD_URL=ftp://ftp.gnu.org/gnu/gmp/gmp-5.1.1.tar.bz2

. install_scripts/incl.sh
TARBALL=${SRC_DIR}/tarballs/${PKG}-${VERSION}.tar.bz2

if_done_exit
start_build
download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xjf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run ./configure --prefix=${INSTALL_DIR} \
      CXX=icpc \
      CXX_FLAGS="-mkl" \
      CC=icc \
      C_FLAGS="-mkl" \
      --enable-cxx
echo_and_run make
echo_and_run make check
echo_and_run make install
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads ${PKG}:

${DESCRIPTION}

Updating LIBRARY_PATH, LD_LIBRARY_PATH, and CPLUS_INCLUDE_PATH environment variables. 

Sets ${PKG^^}_DIR environment variable.

Version: ${VERSION}
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
prepend_path("C_INCLUDE_PATH", pkg_include)

setenv("${PKG^^}_DIR", base)
EOF

# Remove source
rm -rf ${PKG_SRC_DIR}

finish_build