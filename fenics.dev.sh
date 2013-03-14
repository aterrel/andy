#/bin/bash

PKG=fenics
VERSION=dev
ROOT_DIR=${WORK}/opt
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

# Update and install all fenics packages
./install_scripts/fiat.dev.sh
./install_scripts/ufl.dev.sh
./install_scripts/ufc.dev.sh
./install_scripts/ffc.dev.sh
./install_scripts/instant.dev.sh
./install_scripts/dolfin.dev.sh


# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads the FEniCS Packages

]])     

whatis("Description: FEniCS Packages")
whatis("URL: https://launchpad.net/fenics")


-- Needed tools
load("python",
     "elementtree",
     "bzr",
     "icu",
     "boost/1.52.0",
     "armadillo",
     "petsc/3.3-cxx",
     "slepc/3.3-cxx",
     "pmetis",
     "ScientificPython",
     "gmp",
     "mpfr",
     "CGAL",
     "cmake",
     "phdf5",
     "mkl",
     "scotch")


prepend_path("CPLUS_INCLUDE_PATH", os.getenv("TACC_HDF5_INC"))
prepend_path("PATH", os.getenv("TACC_HDF5_BIN"))
prepend_path("CPLUS_INCLUDE_PATH", os.getenv("TACC_TRILINOS_INC"))
prepend_path("LD_LIBRARY_PATH", os.getenv("TACC_TRILINOS_LIB"))


-- FEniCS Packages
load("ufl",
     "ufc",
     "fiat",
     "ffc",
     "instant",
     "dolfin")
EOF
