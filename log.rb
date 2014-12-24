require 'logger'

class Log
  def initialize(file, std)
    unless file.nil?
      @file_log = Logger.new(file)
    end

    if std == true
      @std_log = Logger.new(STDOUT)
    end
  end

  def print_file_log(content)
    @file_log.info content
  end

  def print_std_log(content)
    @std_log.info content
  end
end

LOG = Log.new("log.txt", true)