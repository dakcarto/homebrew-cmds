Homebrew-Cmds
==============

Some external commands for the Homebrew package installer on Mac that I find 
useful.

brew-stack
----------

Installs a formula and its dependencies from pre-made bottles (from official 
Homebrew-* upstream taps) or as built bottles.

**Useful for:**

 * Creating a portable Homebrew directory for a specific OS version.
 
   *Example:* portable domain-specific software stack in custom Homebrew prefix.
    
 * Creating a base install of dependency packages that will later be bundled 
   into a parent application, which is then distributed and expected to run on 
   as many Macs as possible for the given OS version (just like bottles do).
   
   *Example:* large CMake-built application, external to Homebrew, which links 
   to libraries in a dependency 'stack' of Homebrew bottle-builds, that is then
   bundled into a standalone .app using [CMake's BundleUtilities][butils].

[butils]: http://www.cmake.org/cmake/help/v3.0/module/BundleUtilities.html

**Example output:**

```
$ brew stack -h
  Usage: brew stack [install-options...] formula [formula-options...]

         Same options as for `brew install`, but only for a single formula.
         Note: --interactive install option is not supported

$ brew stack tippecanoe
######################################################################## 100.0%
==> brew install tippecanoe --only-dependencies
==> Installing dependencies for tippecanoe: protobuf, protobuf-c
==> Installing tippecanoe dependency: protobuf
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/protobuf-2.6.1.mavericks.bottle
######################################################################## 100.0%
==> Pouring protobuf-2.6.1.mavericks.bottle.1.tar.gz
==> Caveats
Editor support and examples have been installed to:
  /usr/local/Cellar/protobuf/2.6.1/share/doc/protobuf
==> Summary
  /usr/local/Cellar/protobuf/2.6.1: 81 files, 7.1M
==> Installing tippecanoe dependency: protobuf-c
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/protobuf-c-1.0.2.mavericks.bott
######################################################################## 100.0%
==> Pouring protobuf-c-1.0.2.mavericks.bottle.tar.gz
  /usr/local/Cellar/protobuf-c/1.0.2: 10 files, 304K
==> Installed deps: protobuf, protobuf-c
==> brew postinstall protobuf
==> brew postinstall protobuf-c
==> brew install tippecanoe --build-bottle
==> Downloading https://github.com/mapbox/tippecanoe/archive/v1.0.2.tar.gz
######################################################################## 100.0%
==> make
==> make install PREFIX=/usr/local/Cellar/tippecanoe/1.0.2
==> Not running post_install as we're building a bottle
You can run it manually using `brew postinstall tippecanoe`
  /usr/local/Cellar/tippecanoe/1.0.2: 4 files, 164K, built in 2 seconds
==> brew postinstall tippecanoe
```
