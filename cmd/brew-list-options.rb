# Lists all installed formulae and their options.
#
# Useful for recreating a Homebrew directory.

require "formula"
require "formula_installer"
require "tab"
require "utils"

def usage; <<-EOS
  Usage: brew list-options [formula]

         Lists installed formula[e] and used options
  EOS
end

if ARGV.include?("--help") || ARGV.include?("h")
  puts usage
  exit 0
end

kegs = ARGV.kegs

if kegs.length == 0
  installed = %x[ls #{HOMEBREW_PREFIX+"opt"}]
  installed.each do |k|
    kegs << k
  end
end

exit 0


# Install main formula's dependencies first
pre_deps_list = %x[brew list].split("\n")
unless system_out "brew", "install", "#{f}", *(opts + %W[--only-dependencies])
  exit! 1
end
post_deps_list = %x[brew list].split("\n")

# Run post_install for any newly installed formulae
# (post_install is now skipped for bottle builds)
installed_deps = post_deps_list - pre_deps_list
if installed_deps.length > 0
  ohai "Installed deps: " + installed_deps.join(", ")
  installed_deps.each do |d|
    system_out "brew", "postinstall", "#{d}"
  end
end

# Unset to ensure bottle for main formula is poured, if pourable
ENV.delete "HOMEBREW_BUILD_BOTTLE"

# Is main formula pourable?
pour_bottle = false
unless ARGV.build_bottle? # --build-bottle defined
  fi = FormulaInstaller.new(f)
  fi.options             = f.build.used_options
  fi.build_bottle        = ARGV.build_bottle?
  fi.build_from_source   = ARGV.build_from_source?
  fi.force_bottle        = ARGV.force_bottle?

  pour_bottle = fi.pour_bottle?
  opts |= %W[--build-bottle] if ARGV.build_from_source? or !pour_bottle
end

# Necessary to raise error if bottle fails to pour
ENV["HOMEBREW_DEVELOPER"] = "1" if pour_bottle

# Pour or install main formula
if system_out "brew", "install", "#{f}", *opts
  system_out "brew", "postinstall", "#{f}"
else
  if pour_bottle
    opoo "Bottle may have failed to install"
    ohai "Attempting to build source as bottle"
    opts |= %W[--build-bottle]

    if system_out "brew", "install", "#{f}", *opts
      system_out "brew", "postinstall", "#{f}"
    else
      odie "Source bottle build failed"
    end
  else
    odie "Source bottle build failed"
  end
end

exit 0
