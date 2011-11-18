require 'httparty'

module PivotalTracker
  class Connection
    include HTTParty

    attr_reader :config

    base_uri "www.pivotaltracker.com/services/v3"
    format :xml

    def initialize(options = {})
      @config = Config.new(options)
    end

    def request(path, query = {})
      Connection.get(path,
        :headers => { "X-TrackerToken" => @config.pivotal.token },
        :query => query
      )
    end
  end
end