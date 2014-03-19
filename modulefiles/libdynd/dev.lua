-- -*- lua -*-
help(
[[programming
This module loads the development version of programming
]])     

local version = "libdynd-dev"
local base    = pathJoin("/Users/aterrel/workspace/opt/apps/libdynd", version)

whatis("Description: Data Description Language")
whatis("URL: http://libdynd.pydata.org")

local pkg_build = pathJoin(base, "build")
prepend_path("DYLD_LIBRARY_PATH", pkg_build)
prepend_path("PATH", pkg_build)
setenv("LIBDYND_DIR", pkg_build)