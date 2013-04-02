#/bin/bash

set -e

PKG=p4est
DESCRIPTION="Dynamic management of a collection of adaptive octrees, conveniently called a forest of octrees"
VERSION=0.3.4
URL=http://www.p4est.org
DOWNLOAD_URL=http://burstedde.ins.uni-bonn.de/release/p4est-0.3.4.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build
download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
module load openmpi
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


local pkg_bin = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")

prepend_path("PATH", pkg_bin)
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("C_INCLUDE_PATH", pkg_include)

setenv("${PKG^^}_DIR", base)
EOF

# Remove source
rm -rf ${PKG_SRC_DIR}

finish_build
