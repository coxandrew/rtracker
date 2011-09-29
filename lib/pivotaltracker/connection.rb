require 'httparty'

module PivotalTracker
  class Connection
    include HTTParty

    base_uri "www.pivotaltracker.com/services/v3"
    format :xml

    def initialize(token = "d16dddbdd03adf75eeca86e55e4031b5")
      @token = token
    end

    def request(path, query = {})
      Connection.get(path,
        :headers => { "X-TrackerToken" => @token },
        :query => query
      )
    end
  end
end