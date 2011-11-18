require 'logging'

module PivotalTracker
  def self.logger
    logger = Logging.logger['cron']
    logger.add_appenders(
      Logging.appenders.stdout,
      Logging.appenders.rolling_file(
        'rtracker.log',
        :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l %c: %m\n')
      )
    )
    
    logger.level = :info
    
    return logger
  end
end