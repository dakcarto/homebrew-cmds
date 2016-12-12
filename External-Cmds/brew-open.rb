require "formula"
require "utils"

def usage; <<-EOS
  Usage: brew open <single-formula-name>
EOS
end

if ARGV.formulae.length != 1
  puts usage
  exit 1
end

f = ARGV.formulae.first
op = f.opt_prefix

odie "No install at #{op}" if !op.directory? || op.children.empty?

`open #{op}`
exit 0
