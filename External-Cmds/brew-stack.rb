# Install a formula and dependencies from pre-made bottles or as built bottles.
#
# Useful for creating a portable Homebrew directory for a specific OS version.
# Example: portable domain-specific software stack in custom Homebrew prefix

require "formula"
require "formula_installer"
require "utils"

def usage; <<-EOS
  Usage: brew stack [install-options...] formula [formula-options...]

         Same options as for `brew install`, but only for a single formula.
         Note: --interactive install option is not supported
EOS
end

def system_out cmd, *args
  # echo command
  puts "#{Tty.blue}==>#{Tty.blue} #{cmd} #{args*' '}#{Tty.reset}" unless ARGV.verbose?
  # sync output to tty
  # stdout_prev, stderr_prev = $stdout.sync, $stderr.sync
  # $stdout.sync, $stderr.sync = true, true
  res = Homebrew.system cmd, *args
  # $stdout.sync, $stderr.sync = stdout_prev, stderr_prev
  res
end

if ARGV.formulae.length != 1 || ARGV.interactive?
  puts usage
  exit 1
end

if ARGV.include? "--help"
  puts usage
  exit 0
end

f = ARGV.formulae[0]
# opts = ARGV.options_only

# Check if already installed
if f.installed?
  deps_outd = %x(brew outdated).split("\n")
  if deps_outd.include?(f.to_s)
    ohai "#{f} installed, but upgradable"
  else
    odie "#{f} already installed"
  end
end

# Necessary to get dependencies to build as bottle if they install from source
# ENV["HOMEBREW_BUILD_BOTTLE"] = "1"

def install_bottle f1
  f = Formula["#{f1}"]
  opts = ARGV.options_only
  # Is formula pourable?
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
  if pour_bottle
    ENV["HOMEBREW_DEVELOPER"] = "1"
  elsif ENV.include? "HOMEBREW_DEVELOPER"
    ENV.delete "HOMEBREW_DEVELOPER"
  end

  deps_outd = %x(brew outdated).split("\n")
  #   puts "deps_outd (install #{f1}): #{deps_outd}" if deps_outd.length > 0
  install_act = deps_outd.include?(f1) ? "upgrade" : "install"

  # Pour or install formula
  if system_out "brew", "#{install_act}", "#{f1}", *opts
    system_out "brew", "postinstall", "#{f1}"
  else
    if pour_bottle
      opoo "Bottle may have failed to install"
      ohai "Attempting to build source as bottle"
      opts |= %W[--build-bottle]

      if system_out "brew", "#{install_act}", "#{f1}", *opts
        system_out "brew", "postinstall", "#{f1}"
      else
        odie "Source bottle build failed"
      end
    else
      odie "Source bottle build failed"
    end
  end
end

def install_bottles f2
  # first get list of top-level deps
  deps_need = %x(brew deps --1 -n --include-build #{f2}).split("\n")
  puts "deps_need (#{f2}): #{deps_need}" # if deps_need.length > 0
  deps_have = %x(brew deps --1 -n --include-build --installed #{f2}).split("\n")
  # outdated needs to be refreshed as formulae are installed
  deps_outd = %x(brew outdated).split("\n")
  deps_inout = deps_outd & deps_need
  puts "deps_inout (#{f2}): #{deps_inout}" # if deps_inout.length > 0
  deps_have -= deps_inout
  puts "deps_have (#{f2}): #{deps_have}" # if deps_have.length > 0
  deps_todo = deps_need - deps_have
  puts "deps_todo (#{f2}): #{deps_todo}"
  if deps_todo.length > 0
    # keep drilling down
    deps_todo << f2 # otherwise recursion exits
    deps_todo.each do |d|
      deps_outd = %x(brew outdated).split("\n")
      installed = %x(brew list).split("\n")
      next if (installed.include?(d) && ! deps_outd.include?(d))
      install_bottles d
    end
  else
    # nothing left to resolve, install dep
    deps_outd = %x(brew outdated).split("\n")
    installed = %x(brew list).split("\n")
    install_bottle(f2) if (deps_outd.include?(f2) || ! installed.include?(f2))
  end
end

install_bottles f.to_s
# install_bottle f

# Install main formula's dependencies first
# pre_deps_list = %x[brew list].split("\n")
# unless system_out "brew", "install", "#{f}", *(opts + %W[--only-dependencies])
#   exit! 1
# end
# post_deps_list = %x[brew list].split("\n")

# Run post_install for any newly installed formulae
# (post_install is now skipped for bottle builds)
# installed_deps = post_deps_list - pre_deps_list
# if installed_deps.length > 0
#   ohai "Installed deps: " + installed_deps.join(", ")
#   installed_deps.each do |d|
#     system_out "brew", "postinstall", "#{d}"
#   end
# end

# Unset to ensure bottle for main formula is poured, if pourable
# ENV.delete "HOMEBREW_BUILD_BOTTLE"

exit 0
