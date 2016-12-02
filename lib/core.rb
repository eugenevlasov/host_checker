require_relative 'utils'
require_relative 'config'
require_relative 'statistic'
require_relative 'mailer'
require 'rufus-scheduler'
require 'httpclient'


module HostChecker
  class Core
    attr_reader :config
    attr_reader :http_clients
    attr_accessor :threads
    attr_reader :statistics
    attr_accessor :cron_jobs
    attr_reader :mailers

    def initialize(args={})
      @config = Config.new(args)
      @http_clients = {}
      @threads = []
      @statistics = {}
      @cron_jobs = {}
      @mailers = {}
    end

    def run
      puts config.hosts_to_check
      scheduler = Rufus::Scheduler.new
      hosts_to_check.each do |host|
        threads << Thread.new do
          scheduler.every "#{host['period']}s" do |job|
            statistic = statistics[host['url']] ||= Statistic.new
            mailer = mailers[host['url']] = Mailer.new(host['url'], host['notification']['email'])
            job.next_time = unless check_host(host)
                              statistic.down
                              notificate_about_down(host, statistic)
                              puts statistic.to_s
                              Time.now + 1
                            else
                              statistic.up
                              notificate_about_up(host, statistic)
                              Time.now + host['period'].to_i * 60

                            end
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
    def notificate_about_down(host, statistic)
      if [1, 10, 50, 100].include?(statistic.attempt_count) && host['notification']['email']
        mailers[host['url']].notificate_down(statistic.up_at, statistic.down_at, statistic.attempt_count)
      end
    end
    def notificate_about_up(host, statistic)
      if host['notification']['email']
        mailers[host['url']].notificate_up(statistic.up_at, statistic.down_at, statistic.attempt_count)
      end
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