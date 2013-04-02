#/bin/bash

PKG=fenics
VERSION=1.2.0
DESCRIPTION="A collection of free software with an extensive list of features for automated, efficient solution of differential equations."
URL=http://fenicsproject.org

. install_scripts/incl.sh

start_build

# Update and install all fenics dependencies
./install_scripts/anaconda-1.4.0.sh
./install_scripts/icu.4c.50.1.2.sh
./install_scripts/boost.1.52.0.sh
./install_scripts/armadillo-3.800.2.sh
./install_scripts/gmp-5.1.1.sh
./install_scripts/mpfr-3.1.2.sh
./install_scripts/cgal.4.1.sh
./install_scripts/petsc-3.3-p6.sh
./install_scripts/slepc-3.3-p3.sh
./install_scripts/swig-2.0.9.sh
./install_scripts/ScientificPython.2.9.2.sh

# Update and install all fenics packages
./install_scripts/ufc-2.2.0.sh
./install_scripts/fiat-1.1.sh
./install_scripts/ffc-1.2.0.sh
./install_scripts/instant-1.2.0.sh
./install_scripts/ufl-1.2.0.sh
./install_scripts/viper-1.0.1.sh
./install_scripts/dolfin-1.2.0.sh


# Write modulefile
mkdir -p ${MODULE_DIR}
cat << EOF > ${MODULEFILE}
-- -*- lua -*-
help(
[[
This module loads ${PKG}:

${DESCRIPTION}

This is module loads all the dependent packages and parts of the FEniCS project.

Version:${VERSION}
]])     

whatis("Description: ${DESCRIPTION}")
whatis("URL: ${URL} ")


-- Needed tools
load("sl6",
     "anaconda",
     "intel",
     "openmpi",
     "phdf5",
     "icu",
     "boost/1.52.0",
     "armadillo",
     "petsc",
     "slepc",
     "ScientificPython",
     "gmp",
     "mpfr",
     "CGAL",
     "cmake",
     "swig")

-- FEniCS Packages
load("ufl/1.2.0",
     "ufc/2.2.0",
     "fiat/1.1",
     "ffc/1.2.0",
     "instant/1.2.0",
     "dolfin/1.2.0")

-- FEniCS Applications

EOF
finish_build