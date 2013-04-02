#/bin/bash

PKG=fiat
VERSION=1.1
DESCRIPTION="The FInite element Automatic Tabulator FIAT supports generation of arbitrary order instances of the Lagrange elements on lines, triangles, and tetrahedra. It is also capable of generating arbitrary order instances of Jacobi-type quadrature rules on the same element shapes."
URL=http://fenicsproject.org/
DOWNLOAD_URL=https://launchpad.net/fiat/1.1.x/release-1.1/+download/fiat-1.1.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build
download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
module load anaconda ScientificPython ufc swig fiat
echo_and_run python setup.py install --prefix=${INSTALL_DIR}
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the ${PKG} python library

${DESCRIPTION}

It updates the PYTHONPATH environment variable.

Requires a python module be loaded.

Version: ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

prereq("python", "ScientificPython")

local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
prepend_path("PYTHONPATH", pkg_py)
EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build