-- -*- lua -*-
help(
[[programming
This module loads the development version of programming
]])     

local version = "blz-dev"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/blz", version)

whatis("Description: Data Description Language")
whatis("URL: http://blz.pydata.org")

local pkg_build = pathJoin(base, "lib/python2.7/site-packages/")
prepend_path("PYTHONPATH", pkg_build)
setenv("BLZ_DIR", pkg_build)