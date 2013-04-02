#/bin/bash

set -e

PKG=swig
VERSION=2.0.9
DESCRIPTION="Wrapper generators"
URL=http://www.swig.org
DOWNLOAD_URL="http://downloads.sourceforge.net/project/swig/swig/swig-2.0.9/swig-2.0.9.tar.gz?r=http%3A%2F%2Fwww.swig.org%2Fdownload.html&ts=1364844943&use_mirror=iweb"

. install_scripts/incl.sh

if_done_exit
start_build

download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
module load boost anaconda
pushd ${PKG_SRC_DIR}
#echo_and_run ./configure --prefix=${INSTALL_DIR}
echo_and_run make
echo_and_run make install
popd

# Write modulefile
echo_and_run mkdir -p `dirname ${MODULEFILE}`
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} : ${DESCRIPTION}

The following environment variable is added: ${PKG^^}_DIR

Updating PATH,and MANPATH environment variables.

Version ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

local pkg_bin = pathJoin(base, "bin")
local pkg_man = pathJoin(base, "share/man")
prepend_path("PATH", pkg_bin)
prepend_path("MANPATH", pkg_man)

setenv("${PKG^^}_DIR", base)
EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build