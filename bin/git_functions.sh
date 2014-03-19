#!/bin/bash

function git_dirty {
    local st=$(git status 2>/dev/null | tail -n 1)
    if [[ "${st}" == nothing* ]]; then
        echo 0
    else
        echo 1
     fi
}

function git_branchname
{
    echo $(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

