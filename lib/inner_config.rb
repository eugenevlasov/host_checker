module HostChecker
  class InnerConfig
    class NoInnerConfigFile < StandardError; end
    attr_reader :smtp_host
    attr_reader :smtp_port
    def initialize(args={})
      @smtp_host = 'localhost'
      @smtp_port = 1025
      @config_file = args.fetch(:config_file, './config/hostchecker.yml')
      parse_params
    end
    private
    def parse_params
      begin
        @params = YAML::load(File.read(@config_file))
      rescue => e
        # FIXME в случае ошибки логировать
      end
    end
  end
end