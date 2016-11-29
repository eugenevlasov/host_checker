# require 'lib/host_checker'
require 'optparse'

# host_checker = HostChecker.new

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby host_checker.rb [options]"

  opts.on("-c", "--config", "Config file .yml") do |v|
    options[:verbose] = v
  end
end.parse!

p options
p ARGV