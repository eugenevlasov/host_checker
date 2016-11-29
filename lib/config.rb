require 'YAML'
module HostChecker

  class IncorrectConfig < StandardError; end
  class NoHostToCheck < StandardError; end
  class NoConfigFile <StandardError; end;
  class Config
    attr_reader :params
    attr_reader :hosts
    attr_reader :config_file
    def initialize(args={})
      puts Dir.pwd
      @hosts = []
      @config_file = args.fetch(:config_file, './config/hosts.yml')
      begin
      @params = YAML::load(File.read(config_file))
      rescue => e
        raise NoConfigFile.new(msg = e.msg)
      end
      check_and_convert_params

    end
    def hosts_to_check
      @hosts
    end
    private
    def check_and_convert_params
      hosts = params['hosts']
      raise IncorrectConfig unless hosts
      raise NoHostToCheck if hosts.keys.empty?

      hosts.keys.each do |host|
        # hosts[key].keys.empty?
        @hosts << hosts[host]
      end
    end

  end
end