module HostChecker
  class Utils
    def self.convert_to_cron_string(minutes)
      "0/#{minutes} * * * *"
    end
    def self.humanize_time_interval(seconds)
      [[60, :с], [60, :м], [24, :ч], [1000, :д]].map{ |count, name|
        if seconds > 0
          seconds, n = seconds.divmod(count)
          "#{n.to_i} #{name}"
        end
      }.compact.reverse.join(' ')
    end

  end
end
