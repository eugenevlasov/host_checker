module HostChecker
  class BaseNotificator
    def initialize(host)
      @host = host
    end
    def notificate_down(up_at, down_at, attempt_count)
      @message = "#{@host} up at #{up_at} down at #{down_at}"
      @message << "check attempt count: #{attempt_count}" if attempt_count != 0
    end
    def notificate_up(up_at, down_at, attempt_count)
      @message = "#{@host} up at #{up_at} down at #{down_at} downtime: #{downtime}"
    end
  end
end