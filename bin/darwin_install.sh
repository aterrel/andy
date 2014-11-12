#!/bin/bash

set -e
set -x

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install tmux emacs
