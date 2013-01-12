#/bin/bash

PKG=fenics
VERSION=dev
ROOT_DIR=${WORK}/opt
MODULE_DIR=${ROOT_DIR}/modulefiles/${PKG}
MODULEFILE=${MODULE_DIR}/${VERSION}.lua

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
     "boost",
     "armadillo",
     "petsc/3.3-cxx",
     "slepc/3.3-cxx",
     "pmetis",
     "ScientificPython")

-- FEniCS Packages
load("ufl",
     "ufc",
     "fiat",
     "ffc",
     "instant")

EOF