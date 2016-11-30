module HostChecker

  class Statistic
    attr_reader :up_at
    attr_reader :down_at
    attr_reader :attempt_count
    def initialize
      @attempt_count = 0
    end
    def up(time=Time.now)
      @attempt_count = 0
      @down_at = nil
      @up_at ||= time
      nil
    end
    def down(time=Time.now)
      @up_at = nil
      @down_at ||= time
      @attempt_count +=1
    end
    def down_time
      Time.now - @down_at
    end
    def is_down?
      !@down_at.nil?
    end
    def to_s
      if is_down?
        "down at:#{down_at}; attempt count: #{attempt_count} down time #{down_time}"
      else
        "is up"
        end
    end
  end
end