require 'lib/commandant'
include Commandant

command :main do
  print "main"
end

command :argprinter do |args|
  print args.inspect
end

run
