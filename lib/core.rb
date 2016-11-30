require_relative 'utils'
require_relative 'config'
require_relative 'statistic'
require 'rufus-scheduler'
require 'httpclient'

module HostChecker
  class Core
    attr_reader :config
    attr_reader :http_clients
    attr_accessor :threads
    attr_reader :statistics
    attr_accessor :cron_jobs

    def initialize(args={})
      @config = Config.new(args)
      @http_clients = {}
      @threads = []
      @statistics = {}
      @cron_jobs = {}
    end

    def run
      puts config.hosts_to_check
      scheduler = Rufus::Scheduler.new
      hosts_to_check.each do |host|
        threads << Thread.new do
          scheduler.every "#{host['period']}s" do |job|
            statistics[host['url']] ||= Statistic.new
            job.next_time = unless check_host(host)
                              statistics[host['url']].down
                              Time.now + 1
                            else
                              statistics[host['url']].up
                              Time.now + host['period'].to_i * 60

                            end
            puts statistics
          end
          scheduler.join
        end
      end
      threads.collect(&:join)
    end

    private
    def client(host)
      @http_clients[host["url"]] ||= HTTPClient.new
    end

    def hosts_to_check
      config.hosts_to_check
    end

    def check_host(host)

      answer = client(host).get(host["url"])
      puts "#{Time.now} #{host["url"]} status: #{answer.status}"
      return false unless (200..399).to_a.include?(answer.status)
      true
    rescue SocketError => e
      puts "#{Time.now} #{host["url"]} #{e.message}"
      false
    end
  end
end