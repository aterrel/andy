-- -*- lua -*-
help(
[[
This module loads the anaconda : Python distribution for large-scale data processing

Updating PATH environment variables. Setting ANACONDA_DIR
]])     

local version = "1.8.0"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/anaconda", version)

whatis("Description: anaconda: Python distribution for large-scale data processing")
whatis("URL: https://store.continuum.io/cshop/anaconda")

local pkg_bin = pathJoin(base, "bin")
prepend_path("PATH", pkg_bin)

setenv("ANACONDA_DIR", base)
