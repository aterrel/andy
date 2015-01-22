#!/bin/bash

set -e
set -x

DOWNLOAD_DIR=${ANDY_SRC_DIR:=$PWD}
MINICONDA_SH=${DOWNLOAD_DIR}/miniconda.sh
ANACONDA_INSTALL=${ANDY_INSTALL_DIR:=$PWD}/anaconda
ANACONDA_BIN=${ANACONDA_INSTALL}/bin
UNAME=`uname`

if  ! hash conda 2>/dev/null; then
    mkdir -p `dirname ${MINICONDA_SH}`
    if [ $UNAME == "Linux" ]; then
        if [ `uname -m` == "x86_64" ]; then
            wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O ${MINICONDA_SH}
        else
            wget http://repo.continuum.io/miniconda/Miniconda-3.7.0-Linux-x86.sh -O ${MINICONDA_SH}
        fi
    elif [ $UNAME == "Darwin" ]; then
        wget http://repo.continuum.io/miniconda/Miniconda-latest-MacOSX-x86_64.sh -O ${MINICONDA_SH}
    fi
    rm -rf ${ANACONDA_INSTALL}
    bash ${DOWNLOAD_DIR}/miniconda.sh -b -p ${ANACONDA_INSTALL}
    export PATH=${ANACONDA_BIN}:$PATH
    echo "path_prepend ${ANACONDA_BIN}" >> ${HOME}/.bash_local
    conda config --set always_yes yes
    conda config --add create_default_packages pip --add create_default_packages ipython
    conda update conda --yes
fi
