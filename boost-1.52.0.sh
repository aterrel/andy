#/bin/bash

set -e

PKG=boost
VERSION=1.52.0
DESCRIPTION="Free peer-reviewed portable C++ source libraries"
URL=http://www.boost.org
DOWNLOAD_URL="http://downloads.sourceforge.net/project/boost/boost/1.52.0/boost_1_52_0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F1.52.0%2F&ts=1364826496&use_mirror=hivelocity"

. install_scripts/incl.sh
PKG_SRC_DIR=${SRC_DIR}/${PKG}_1_52_0
TARBALL=${SRC_DIR}/tarballs/${PKG}_1_52_0.tar.gz

if_done_exit
start_build

echo_and_run module purge
echo_and_run module load sl6 anaconda intel icu openmpi
download_tarball

# Remove previous source and unpack tarball
echo_and_run rm -rf ${PKG_SRC_DIR}
echo_and_run tar -xzf ${TARBALL}

# # Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run ./bootstrap.sh --prefix=${INSTALL_DIR} \
               --with-toolset=intel-linux \
               --with-icu=${ICU_DIR} 
echo "using mpi ;" >> tools/build/v2/user-config.jam
echo_and_run ./b2 install
popd

# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
help([[
This module loads the ${PKG} : ${DESCRIPTION}

The following environment variables are added:
BOOST_ROOT, BOOST_DIR, BOOST_LIB, and BOOST_INC

The following environment variables are updated:
LD_LIBRARY_PATH, LIBRARY_PATH, CPLUS_INCLUDE_PATH

Version ${VERSION}
]])

whatis("Name: boost")
whatis("Version: ${VERSION}")
whatis("Category: ${GROUP}")
whatis("Keywords: System, Library, C++")
whatis("URL: http://www.boost.org")
whatis("Description: ${DESCRIPTION}")

setenv("BOOST_ROOT","${INSTALL_DIR}")
setenv("BOOST_DIR","${INSTALL_DIR}")
setenv("BOOST_LIB","${INSTALL_DIR}/lib")
setenv("BOOST_INC","${INSTALL_DIR}/include")

-- Add boost to the LD_LIBRARY_PATH
prepend_path("LD_LIBRARY_PATH","${INSTALL_DIR}/lib")
prepend_path("LIBRARY_PATH", "${INSTALL_DIR}/lib")
prepend_path("CPLUS_INCLUDE_PATH", "${INSTALL_DIR}/include")

EOF

# Remove source
echo_and_run rm -rf ${PKG_SRC_DIR}

finish_build