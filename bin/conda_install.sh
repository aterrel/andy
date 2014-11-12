#!/bin/bash

set -e

DOWNLOAD_DIR=${ANDY_SRC_DIR:=$PWD}
MINICONDA_SH=${DOWNLOAD_DIR}
ANACONDA_INSTALL=${ANDY_INSTALL_DIR:=$PWD}/anaconda
ANACONDA_BIN=${ANACONDA_INSTALL}/bin
UNAME=`uname`

if hash conda 2>&1 /dev/null; then
    if [ $UNAME == "Linux" ]; then
        wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O ${MINICONDA_SH}
    elif [ $UNAME == "Darwin" ]; then
        wget http://repo.continuum.io/miniconda/Miniconda-latest-MacOSX-x86_64.sh -O ${MINICONDA_SH}
    fi
    bash ${DOWNLOAD_DIR}/miniconda.sh -b -p ${ANACONDA_INSTALL}
    path_prepend ${ANACONDA_BIN}
    echo "path_prepend ${ANACONDA_BIN}" >> ${HOME}/.bash_local
    conda config --set always_yes yes
    conda config --add create_default_packages pip --add create_default_packages ipython
    conda update conda --yes
fi
