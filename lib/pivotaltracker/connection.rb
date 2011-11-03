require 'httparty'

module PivotalTracker
  class Connection
    include HTTParty

    attr_reader :config

    base_uri "www.pivotaltracker.com/services/v3"
    format :xml

    def initialize(config_file = "config.yml")
      @config = Config.new(config_file)
    end

    def request(path, query = {})
      Connection.get(path,
        :headers => { "X-TrackerToken" => @config.pivotal.token },
        :query => query
      )
    end
  end
end