require './lib/core'
require 'optparse'

# host_checker = HostChecker.new

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby host_checker.rb [options]"

  opts.on("-c", "--config", "Config file .yml") do |v|
    options[:config_file] = v
  end
end.parse!

host_checker = HostChecker::Core.new(options)
host_checker.run
