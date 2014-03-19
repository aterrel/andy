-- -*- lua -*-
help(
[[
This module loads the development version of hashstack
]])     

local hdist_base    = "/Users/aterrel/workspace/opt/apps/hashstack/hashdist"

whatis("Description: Hashstack build")
whatis("URL: ")

local hdist_path = pathJoin(hdist_base, "bin")
prepend_path("PATH", hdist_path)
