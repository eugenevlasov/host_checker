module HostChecker

  class Statistic
    attr_reader :up_at
    attr_reader :down_at
    attr_accessor :attempt_count
    def initialize
      @attempt_count = 0
    end
    def up(time=Time.now)
      self.attempt_count = 0
      down_at = nil
      up_at = time
      nil
    end
    def down(time=Time.now)
      up_at = nil
      down_at ||= time
      self.attempt_count +=1
    end
    def down_time
      Time.now - down_at
    end
    def is_down?
      !down_at.nil?
    end
  end
end