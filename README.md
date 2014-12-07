Homebrew-Cmds
==============

Some external commands for the Homebrew package installer on Mac that I find 
useful.

brew-stack
----------

Installs a formula and its dependencies from pre-made bottles (from official 
Homebrew-* upstream taps) or as built bottles.

Useful for:

 * Creating a portable Homebrew directory for a specific OS version.
 
   *Example:* portable domain-specific software stack in custom Homebrew prefix.
    
 * Creating a base install of dependency packages that will later be bundled 
   into a parent application, which is then distributed and expected to run on 
   as many Macs as possible for the given OS version (just like bottles do).
   
   *Example:* large CMake-built application, external to Homebrew, which links 
   to libraries in a dependency 'stack' of Homebrew bottles, that is then 
   bundled into a standalone .app using [CMake's BundleUtilities](http://www.cmake.org/cmake/help/v3.0/module/BundleUtilities.html).
   
```
$ brew stack -h
  Usage: brew stack [install-options...] formula [formula-options...]

         Same options as for `brew install`, but only for a single formula.
         Note: --interactive install option is not supported

$ brew stack openssl
==> brew install openssl --only-dependencies
All dependencies for openssl are satisfied.
==> brew install openssl
==> Downloading https://downloads.sf.net/project/machomebrew/Bottles/openssl-1.0.1j_1.mavericks.bottle
######################################################################## 100.0%
==> Pouring openssl-1.0.1j_1.mavericks.bottle.tar.gz
==> Caveats
...
==> Summary
  /usr/local/Cellar/openssl/1.0.1j_1: 431 files, 15M
==> brew postinstall openssl
```
