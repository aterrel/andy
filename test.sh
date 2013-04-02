#!/bin/bash

set -e


echo_and_run() { echo "\$ $@" | tee -a $LOGFILE; "$@" 2>&1 | tee -a $LOGFILE; }

LOGFILE=logs/foobar.log


echo "" > $LOGFILE
echo_and_run echo "Starting script: `date`"
echo_and_run echo "Ending script: `date`"

