require "formula"
require "utils"

def usage; <<-EOS
  Usage: brew open formula-name

EOS
end

if ARGV.formulae.length != 1
  puts usage
  exit 1
end

f = ARGV.formulae.first

if f.installed?
  %x(open #{f.prefix.parent})
else
  odie "#{f} not installed"
end

exit 0
