-- -*- lua -*-
help(
[[programming
This module loads the development version of programming
]])     

local version = "dynd-python-dev"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/dynd-python", version)

whatis("Description: Data Description Language")
whatis("URL: http://dynd-python.pydata.org")

local pkg_build = pathJoin(base, "build")
prepend_path("PYTHONPATH", pkg_build)
setenv("DYND_PYTHON_DIR", pkg_build)