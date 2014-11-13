#!/bin/bash

set -e
set -x

if ! hash brew 2>/dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install tmux emacs
fi
