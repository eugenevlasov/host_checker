require_relative 'base_notificator'
require 'mail'
module HostChecker
  class Mailer < HostChecker::BaseNotificator
    Mail.defaults do
      delivery_method :smtp, address: "localhost", port: 1025
    end
    def initialize(host, email)
      @mailer = Mail.new do
        from    'alarm@hostchecker.local'
        to      email
      end
      @host = host
    end
    def host_down(up_at, down_at, attempt_count)
      @mailer.subject "#{@host} is down"
      message = "#{@host} up at #{up_at} down at #{down_at}"
      message << "check attempt count: #{attempt_count}" if attempt_count != 0
      @mailer.body message
      @mailer.deliver!
    end
    def host_up(up_at, down_at, downtime)
      @mailer.subject "#{@host} is up"
      message = "#{@host} up at #{up_at} down at #{down_at} downtime: #{downtime}"
      @mailer.body message
      @mailer.deliver!
    end
  end
end