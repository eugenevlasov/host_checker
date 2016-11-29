module HostChecker

  class Statistic
    def initialize
      @attempt_count = 0
    end
    def increase_attempt
      @last_attempt_at = Time.now
      # @attempt_count.increase!
    end
    def last_attempt_at
      @last_attempt_at
    end
    def attempt_count

    end
  end
end