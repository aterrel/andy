Andy's Sanity Scripts of Keeping Installs Simple and Stupid
===========================================================

These scripts are meant to keep [Andy][0] sane as he moves from computer to
computer.  The intention is to create a set of lightweight bash
scripts that are able to install in userspace on a number of machines.
While other heavier weight tools such as [hashdist][1], [nix][2], and
[dorsal][3], I find that I always spend more time debugging the
heavyweight system. A few of the goals are listed below:

- Have a single set of scripts where possible
- Configure specific to machines
- Output lua module files for use with lmod
- Support multiple build hierarchies [TODO]
- Support development of packages with in-source builds of git repos


Usage
-----

1. First set your machine name, this will be used to setup 
    $ export ANDY_INSTALL_MACHINE=<machine_name>

2. Next we need to know a bit of detail about your machine. You can
copy one from machine files and include it in your top dir.
    $ cp machine_confs/conf.default.sh conf.sh

3. Pick a toolchain, roughly defined by as:
   compiler -> mpi_implementation-> <your tool>
    $ cp tool_chains/tool_chain.default.sh tool_chain.sh

4. You can install a package list or a single script
    $ ./andy_install package packages/plist.default.sh
    $ ./andy_install script scripts/<script_name>.sh

5. [NOT IMPLEMENTED] When things break ask to fix shit and you will be
taken to the last place things were installed at.
    $ ./andy_install debug

6. If everything worked, yeah right, you can load and switch things
with module commands.  Each package will have a basic module file to
load everything in it.  To add more packages, just add to the scripts
folder and put the script name in the packages file.

6.1 Add to ${HOME}/.bashrc
    source <path/to/andy_install/conf.sh>
    module load <plist_name>/<tool_chain>

6.2 Swap tool chains
    $ module load <plist_name>/<new_tool_chain>

6.3 Swap just a single tool
    $ module swap petsc petsc/new-intall


Administrivia
-------------

### License
  BSD-2, since that means less paperwork

### Copyright
  University of Texas at Austin since they pay me (or at least 
  take over head from my grants and make me pay for my own damn coffee)

### Support 

This work has been supported by 

* NSF Award OCI-0622780
* Award from DoD ERDC BAA No. W912HZ-11-BAA-02

No, they did not explicitly fund this project, but they are interested
in me installing software on computers for my work and are minimally
interested in my sanity.

### Authors

* Andy R. Terrel of The University of Texas at Austin (use the internet to find me)
* Patrick Farrell of Imperial College (lib-adjoint and dolfin-adjoint patches)


Changelog
---------

v dev
* Canonization scripts
* Add attitude

v0.1-<machine>
* machine dependent scripts


[0]: http://andy.terrel.us/
[1]: http://hashdist.readthedocs.org/
[2]: http://nixos.org/
[3]: https://bitbucket.org/fenics-project/dorsal/
