require_relative 'utils'
module HostChecker

  class Statistic
    attr_reader :up_at
    attr_reader :down_at
    attr_reader :attempt_count
    def initialize
      @attempt_count = 0
    end
    def up(time=Time.now)
      previous_attemp_count = @attempt_count
      @attempt_count = 0
      @previous_down_at = @down_at
      @up_at ||= time
      return previous_attemp_count != 0
    end
    def down(time=Time.now)
      @up_at = nil
      @down_at ||= time
      @attempt_count +=1
    end
    def down_time
      Utils.humanize_time_interval(Time.now - @previous_down_at)
    end
    def is_down?
      @up_at.nil? && !@down_at.nil?
    end
    def to_s
      if is_down?
        "down at:#{down_at}; attempt count: #{attempt_count} downtime #{self.down_time}"
      else
        "is up"
        end
    end
  end
end