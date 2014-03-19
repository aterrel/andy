-- -*- lua -*-
help(
[[
This module loads the development version of blaze
]])     

local version = "blaze-dev"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/blaze", version)
local build   = pathJoin(base, "lib/python2.7/site-packages")

whatis("Description: Distributed Array library")
whatis("URL: http://blaze.pydata.org")

local pkg_py = build
prepend_path("PYTHONPATH", pkg_py)
setenv("BLAZE_DIR", base)
