module HostChecker
  class Utils

    def self.convert_to_cron_string(minutes)
      "0/#{minutes} * * * *"
    end

  end
end
