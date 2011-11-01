require 'httparty'

module PivotalTracker
  class Connection
    include HTTParty

    attr_reader :jira_username,
                :jira_password,
                :pivotal_token

    base_uri "www.pivotaltracker.com/services/v3"
    format :xml

    attr_accessor :token

    def initialize(config_file = "config.yml")
      load_config(config_file)
    end

    def request(path, query = {})
      Connection.get(path,
        :headers => { "X-TrackerToken" => @pivotal_token },
        :query => query
      )
    end

    private

    def load_config(config_file)
      config = YAML::load(File.open(config_file))

      @jira_username = config["jira"]["username"]
      @jira_password = config["jira"]["password"]

      @pivotal_token = config["pivotal"]["api_token"]
    end
  end
end