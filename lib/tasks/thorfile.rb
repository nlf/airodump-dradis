class DradisTasks < Thor
  class Upload < Thor
    namespace "dradis:upload"

    desc  "airodump", "upload airodump results"
    long_desc "Upload an airodmp CSV file to a note"
    def airodump(file_path)
      require 'config/environment'

      logger = Logger.new(STDOUT)
      logger.level = Logger::DEBUG

      unless File.exists?(file_path)
        $stderr.puts "** the file [#{file_path}] does not exist"
        exit -1
      end

      AiroDump.import(
        :file => file_path,
        :logger => logger)

      logger.close
    end

  end
end
