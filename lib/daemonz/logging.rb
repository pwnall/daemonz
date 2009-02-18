module Daemonz
  @logger = RAILS_DEFAULT_LOGGER
  class <<self
    attr_reader :logger
  end
  
  def self.configure_logger
    case config[:logger]
    when 'stdout'
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::DEBUG
    when 'stderr'
      @logger = Logger.new(STDERR)
      @logger.level = Logger::DEBUG
    when 'rails'
      @logger = RAILS_DEFAULT_LOGGER
    end
  end
end
