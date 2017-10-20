require "formula"
require "utils"

def usage; <<-EOS
  Usage: brew cd <single-formula-name>
EOS
end

if ARGV.formulae.length != 1
  puts usage
  exit 1
end

f = ARGV.formulae.first
fpfx = f.prefix

odie "No install at #{fpfx}" if !fpfx.directory? || fpfx.children.empty?

`echo "cd #{fpfx}" | tr "\n" " " | pbcopy`
puts "'cd #{fpfx}' on clipboard"

exit 0
