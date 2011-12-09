require 'logging'

module PivotalTracker
  def self.logger
    Logging.logger.root.appenders = Logging.appenders.file(
      'rtracker.log',
      :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l %c: %m\n')
    )
    Logging.logger.root.add_appenders(Logging.appenders.stdout)
        
    logger = Logging.logger['cron']
    logger.level = :debug
    
    return logger
  end
end