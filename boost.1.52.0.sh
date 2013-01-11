#/bin/bash

PKG=boost
VERSION=1.52.0
ROOT_DIR=${WORK}/opt
SRC_DIR=${ROOT_DIR}/src
INSTALL_DIR=${ROOT_DIR}/apps/${PKG}/${VERSION}
PKG_SRC_DIR=${SRC_DIR}/${PKG}_1_52_0
TARBALL=${PKG_SRC_DIR}.tar.gz
LOGFILE=${SRC_DIR}/${PKG}-${VERSION}.log
MODULEFILE=${ROOT_DIR}/modulefiles/${PKG}/${VERSION}.lua
MKL_LIB_DIR=${MKLROOT}/lib/intel64

# Remove previous source and unpack tarball
rm -rf ${PKG_SRC_DIR}
tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
./bootstrap.sh 2>&1 | tee -a ${LOGFILE}
./b2 --prefix=${INSTALL_DIR} \
     --toolset=intel-linux \
     2>&1 | tee ${LOGFILE}
popd

# Remove source
#rm -rf ${PKG_SRC_DIR}

# Write modulefile
cat << EOF > ${MODULEFILE}
help([[
The boost module file defines the following environment variables:"
BOOST_ROOT, BOOST_DIR, BOOST_LIB, and BOOST_INC for"
the location of the boost distribution."

Version %{version}"
]])

whatis("Name: boost")
whatis("Version: %{version}")
whatis("Category: %{group}")
whatis("Keywords: System, Library, C++")
whatis("URL: http://www.boost.org")
whatis("Description: Boost provides free peer-reviewed portable C++ source libraries.")

setenv("BOOST_ROOT","%{INSTALL_DIR}")
setenv("BOOST_DIR","%{INSTALL_DIR}")
setenv("BOOST_LIB","%{INSTALL_DIR}/lib")
setenv("BOOST_INC","%{INSTALL_DIR}/include")

-- Add boost to the LD_LIBRARY_PATH
prepend_path("LD_LIBRARY_PATH","%{INSTALL_DIR}/lib")

EOF


#--------------
EOF