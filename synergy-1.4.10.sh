#/bin/bash

set -e

PKG=synergy
VERSION=1.4.10
URL=http://synergy-foss.org
DESCRIPTION="A keyboard and mouse sharing tool"
DOWNLOAD_URL=http://synergy.googlecode.com/files/synergy-1.4.10-Source.tar.gz

. install_scripts/incl.sh
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}-Source
BUILD_DIR=${PKG_SRC_DIR}/build/release
TARBALL=${SRC_DIR}/tarballs/${PKG}-${VERSION}-Source.tar.gz

if_done_exit
start_build
download_tarball

echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run ./hm.sh configure -g1 --make-gui
echo_and_run ./hm.sh build --make-gui
echo_and_run mkdir -p ${INSTALL_DIR}
echo_and_run cp -r bin lib ${INSTALL_DIR}
popd

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

# Write modulefile
echo_and_run mkdir -p `dirname ${MODULE_DIR}`
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} : ${DESCRIPTION}

Updating PATH, LIBRARY_PATH, and LD_LIBRARY_PATH environment variables. Setting ${PKG^^}_DIR
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${PKG}: ${DESCRIPTION}")
whatis("URL: ${URL}")

local pkg_bin = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_include = pathJoin(base, "include")
local pkg_man = pathJoin(base, "share/man")
prepend_path("PATH", pkg_bin)
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)

setenv("${PKG^^}_DIR", base)
EOF

finish_build
