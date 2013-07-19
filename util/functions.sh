#!/bin/bash

function divider() {
    s="_"
    o=""
    for i in `seq 1 80`; do o="${o}${s}"; done
    echo $o
}

function download_tarball() {
    if [ ! -f ${TARBALL} ]; then
	pushd tarballs
	echo_and_run wget -nv ${DOWNLOAD_URL}
	popd
    fi
}

function echo_and_run { 
    echo "\$ $@" | tee -a $LOGFILE
    "$@" 2>&1 | tee -a $LOGFILE
    status=${PIPESTATUS[0]}
    if [ $status -ne 0 ]; then
        echo "error with $1"
    fi
    return $status
}

function start_build {
    divider
    echo "Building ${PKG}-${VERSION}"
    divider
    mkdir -p `dirname ${LOGFILE}`
    echo "Starting build: `date`" | tee ${LOGFILE}
}

function finish_build {
    echo "Finishing build: `date`" | tee -a ${LOGFILE}
}

function if_done_exit {
    if [ ${MODULEFILE} -nt $TARBALL ]; then
	echo "Package ${PKG}-${VERSION} already installed"
        echo "  To reinstall remove ${MODULEFILE}"
	exit 0
    fi
}