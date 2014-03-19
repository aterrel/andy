-- -*- lua -*-
help(
[[
This module loads the development version of DataShape
]])     

local version = "datashape-dev"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/datashape", version)

whatis("Description: Data Description Language")
whatis("URL: http://datashape.pydata.org")

local pkg_py = base
prepend_path("PYTHONPATH", pkg_py)
setenv("DATASHAPE_DIR", base)
