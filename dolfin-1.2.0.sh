#/bin/bash

set -e

PKG=dolfin
VERSION=1.2.0
DESCRIPTION="DOLFIN is the C++/Python interface of FEniCS, providing a consistent PSE (Problem Solving Environment) for ordinary and partial differential equations."
URL=http://fenicsproject.org/
DOWNLOAD_URL=https://launchpad.net/dolfin/1.2.x/1.2.0/+download/dolfin-1.2.0.tar.gz

. install_scripts/incl.sh

if_done_exit
start_build
download_tarball

# Remove previous source and unpack tarball
#echo_and_run rm -rf ${PKG_SRC_DIR}
#echo_and_run tar -xzf ${TARBALL}

# Configure and make
pushd ${PKG_SRC_DIR}
echo_and_run module purge
echo_and_run module load sl6 anaconda intel vtk icu boost/1.52.0 openmpi phdf5 armadillo petsc slepc swig cmake gmp mpfr CGAL ScientificPython ufc/2.2.0 ufl/1.2.0 fiat/1.1 ffc/1.2.0 instant/1.2.0 viper/1.0.1
#echo_and_run printf "217\na\n  set(ARMADILLO_TEST_RUNS TRUE)\n.\nw\nq\n" | ed cmake/modules/FindArmadillo.cmake || true
export LD_LIBRARY_PATH=${MKLROOT}/lib/intel64:$LD_LIBRARY_PATH
export LDFLAGS="-L${MKLROOT}/lib/intel64"
echo_and_run cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_COMPILER=/opt/apps/ossw/libraries/openmpi/openmpi-1.6/sl6/intel-12.1/bin/mpicxx \
      -DCMAKE_CXX_FLAGS="-mkl=sequential" \
      -DCMAKE_C_COMPILER=/opt/apps/ossw/libraries/openmpi/openmpi-1.6/sl6/intel-12.1/bin/mpicc \
      -DCMAKE_C_FLAGS="-mkl=sequential" \
      -DCMAKE_LDFLAGS="-L${MKLROOT}/lib/intel64" \
      -DCMAKE_FORTRAN_COMPILER=/opt/apps/ossw/libraries/openmpi/openmpi-1.6/sl6/intel-12.1/bin/mpif90 \
      -DCMAKE_FORTRAN_FLAGS="-mkl=sequential" \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DARMADILLO_INCLUDE_DIRS=${ARMADILLO_DIR}/include \
      -DARMADILLO_LIBRARIES=${ARMADILLO_DIR}/lib/libarmadillo.so \
      -DPYTHON_INCLUDE_DIR=${ANACONDA_DIR}/include/python2.7/ \
      -DPYTHON_LIBRARY=${ANACONDA_DIR}/lib/libpython2.7.so \
      -DPETSC_DIR=${PETSC_DIR} \
      -DSLEPC_DIR=${SLEPC_DIR} \
      -DBLAS_mkl_intel_lp64_LIBRARY=${MKLROOT}/lib/intel64/libmkl_intel_lp64.so \
      -DBLAS_mkl_LIBRARY=${MKLROOT}/lib/intel64/libmkl_core.so \
      -DBLAS_mkl_intel_thread_LIBRARY=${MKLROOT}/lib/intel64/libmkl_thread.so \
      -DBLAS_blas_LIBRARY=${MKLROOT}/lib/intel64/libmkl_blas95_lp.a \
      -DHDF5_IS_PARALLEL=ON \
      -DHDF5_hdf5_LIBRARY=${PHDF5_LIB}/libhdf5.so \
      -DHDF5_hdf5_LIBRARY_RELEASE=${PHDF5_LIB}/libhdf5.so \
      -DVTK_DIR=${VTK_DIR} \
      -DCGAL_DIR=${CGAL_DIR} \
      -DQT_DIR=/usr/lib64/qt4 \
      -DQT_MOC_EXECUTABLE=/usr/lib64/qt4/bin/moc \
      -DQT_RCC_EXECUTABLE=/usr/lib64/qt4/bin/rcc \
      -DQT_UIC_EXECUTABLE=/usr/lib64/qt4/bin/uic

echo_and_run make
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

Updating LIBRARY_PATH, LD_LIBRARY_PATH, CPLUS_INCLUDE_PATH, PATH, PYTHONPATH, PKG_CONFIG_PATH, and MANPATH environment variables.

It also sets the DOLFIN_DIR and DOLFIN_DEMO environment variables.

Version: ${VERSION}
]])     

local version = "${VERSION}"
local base    = "${INSTALL_DIR}"

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL}")

local pkg_path = pathJoin(base, "bin")
local pkg_lib = pathJoin(base, "lib")
local pkg_py = pathJoin(base, "lib/python2.7/site-packages")
local pkg_include = pathJoin(base, "include")
local pkg_man = pathJoin(base, "share/man")
local pkg_demo = pathJoin(base, "share/dolfin/demo")
local pkg_pkgconfig = pathJoin(base, "lib/pkgconfig")

prepend_path("PATH", pkg_path) 
prepend_path("LIBRARY_PATH", pkg_lib)
prepend_path("LD_LIBRARY_PATH", pkg_lib)
prepend_path("CPLUS_INCLUDE_PATH", pkg_include)
prepend_path("PYTHONPATH", pkg_py)
prepend_path("MANPATH", pkg_man)
prepend_path("PKG_CONFIG_PATH", pkg_pkgconfig)


setenv("DOLFIN_DIR", base)
setenv("DOLFIN_DEMO", pkg_demo)
EOF

finish_build