-- -*- lua -*-
help(
[[
This module loads the Andy: Scripts andy uses for stuff.

Updating PATH environment variables. Setting ANDY_DIR
]])

local version = "andy-dev"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/andy", version)

whatis("Description: anaconda: Python distribution for large-scale data processing")
whatis("URL: https://github.com/aterrel/andy")

local pkg_bin = pathJoin(base, "bin")
prepend_path("PATH", pkg_bin)

setenv("ANDY_DIR", base)
