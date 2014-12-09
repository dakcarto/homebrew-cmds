Homebrew-Cmds
==============

Some external commands for the [Homebrew package manager][hb] on Mac that I find
useful.

[hb]: http://brew.sh/

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

$ brew stack cairo
==> brew install cairo --only-dependencies
==> Installing dependencies for cairo: libpng, pixman
==> Installing cairo dependency: libpng
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/libpng-1.6.15.mavericks.bottle.
Already downloaded: /Users/larrys/OSGeo4Mac/osgeo4mac-cache/libpng-1.6.15.mavericks.bottle.tar.gz
==> Pouring libpng-1.6.15.mavericks.bottle.tar.gz
    /usr/local/Cellar/libpng/1.6.15: 17 files, 1.3M
==> Installing cairo dependency: pixman
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/pixman-0.32.6.mavericks.bottle.
######################################################################## 100.0%
==> Pouring pixman-0.32.6.mavericks.bottle.1.tar.gz
    /usr/local/Cellar/pixman/0.32.6: 11 files, 1.4M
==> Installed deps: libpng, pixman
==> brew postinstall libpng
==> brew postinstall pixman
==> brew install cairo
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/cairo-1.14.0.mavericks.bottle.1
######################################################################## 100.0%
==> Pouring cairo-1.14.0.mavericks.bottle.1.tar.gz
    /usr/local/Cellar/cairo/1.14.0: 106 files, 6.4M
==> brew postinstall cairo
```
