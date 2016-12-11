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
puts "Opening #{f.prefix.parent}"
`open #{f.prefix.parent}`

exit 0
