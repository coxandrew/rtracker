module PivotalTracker
  class Config
    attr_accessor :jira, :pivotal
    
    def initialize(config_file)
      load_config(config_file)
    end

    private

    def load_config(config_file)
      config = YAML::load(File.open(config_file))

      @jira = OpenStruct.new(
        :base_uri => config["jira"]["base_uri"],
        :username => config["jira"]["username"],
        :password => config["jira"]["password"]
      )
      @pivotal = OpenStruct.new(
        :token => config["pivotal"]["api_token"]
      )
    end
  end
end