-- -*- lua -*-
help(
[[programming
This module loads the development version of programming
]])     

local version = "python-blosc-dev"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/blosc", version)

whatis("Description:")
whatis("URL: http://blosc.pydata.org")

local pkg_py = pathJoin(base, "lib/python2.7/site-packages/")
prepend_path("PYTHONPATH", pkg_py)
setenv("PYTHON_BLOSC_DIR", base)