-- -*- lua -*-
help(
[[
This module loads the environment variables for CUDA
]])     

local version = "5.5"
local base    = "/Developer/NVIDIA/CUDA-5.5"

whatis("Description: CUDA")
whatis("URL: ")

local pkg_bin = pathJoin(base, "bin")
local pkg_dyld = pathJoin(base, "lib")
prepend_path("PATH", pkg_bin)
prepend_path("DYLD_LIBRARY_PATH", pkg_dyld)

