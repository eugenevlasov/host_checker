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
    def notificate_down(up_at, down_at, attempt_count)
      super(up_at, down_at, attempt_count)
      @mailer.subject "#{@host} is down"

      @mailer.body @message
      @mailer.deliver!
    end
    def notificate_up(up_at, down_at, downtime)
      super(up_at, down_at, attempt_count)
      @mailer.subject "#{@host} is up"
      @mailer.body @message
      @mailer.deliver!
    end
  end
end