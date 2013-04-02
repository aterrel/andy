#/bin/bash

set -e

PKG=slepc
VERSION=3.3-p3
DESCRIPTION="Software library for the solution of large scale sparse eigenvalue problems on parallel computers"
URL=http://grycap.upv.es/slepc/
DOWNLOAD_URL=http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.3-p3.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build

download_tarball

module load petsc

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run ./configure \
     --prefix=${INSTALL_DIR}
echo_and_run make SLEPC_DIR=${PKG_SRC_DIR} PETSC_DIR=${PETSC_DIR} PETSC_ARCH=arch-installed-petsc
echo_and_run make SLEPC_DIR=${PKG_SRC_DIR} PETSC_DIR=${PETSC_DIR} PETSC_ARCH=arch-installed-petsc install
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