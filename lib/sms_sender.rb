require_relative 'base_notificator'
module HostChecker
  class SmsSender < HostChecker::BaseNotificator
    def initialize(phone, host)
      @phone = phone
      @host = host
    end
    def send_sms_down(up_at, down_at, attempt_count)
      super(up_at, down_at, attempt_count)
      send_sms
    end
    def send_sms_up(up_at, down_at)
      super(up_at, down_at, attempt_count)
      send_sms
    end
    private
    def send_sms
      # FIXME найти бесплатные рассылщики смс оказалось непросто
    end
  end
end