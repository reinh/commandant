require 'lib/commander'
include Commander

command :main do
  print "main"
end

command :argprinter do |args|
  print args.inspect
end

run
