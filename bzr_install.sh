#/bin/bash

PKG=bzr
VERSION=2.6b2
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}-${VERSION}
TARBALL=${SRC_DIR}/${PKG}-${VERSION}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULEFILE=${ROOT_DIR}/modulefiles/${PKG}/${VERSION}.lua

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
module load python elementtree
python setup.py install --prefix=${INSTALL_DIR} 2>&1 | tee ${LOGFILE}
popd

# Remove source
rm -rf ${PKG_SRC_DIR}

# Write modulefile
cat << EOF > ${MODULEFILE}
local pkg = pathJoin(work, "${INSTALL_DIR}")
local pkg_bin = pathJoin(pkg, "bin")
local pkg_man = pathJoin(pkg, "man")
local pkg_py = pathJoin(pkg, "lib/python2.7/site-packages")
prepend_path("PATH", pkg_bin)
prepend_path("MANPATH", pkg_man)
prepend_path("PYTHONPATH", pkg_py)
EOF