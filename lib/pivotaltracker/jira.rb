require 'sanitize'
require 'htmlentities'
require 'date'
require 'pp'

module PivotalTracker
  class Jira
    include HTTParty
    
    config = YAML::load(File.open("config.yml"))

    base_uri config["jira"]["base_uri"]
    default_params  :os_username => config["jira"]["username"], 
                    :os_password => config["jira"]["password"]
    
    def initialize(options = {})
      @jira_id = options["jira_id"]
      @logger = PivotalTracker.logger
    end
    
    def bugs(options = {})
      query = { :jql => bug_search_criteria }
      
      self.class.get("/search", :query => query)["issues"].collect do |issue|
        OpenStruct.new(:jira_id => issue["key"])
      end
    end
    
    def self.find(id)
      config = Config.new
      response = get("/issue/#{id}")
      fields = response["fields"]
      
      issue = OpenStruct.new(
        :jira_id      => id,
        :story_type   => fields["issuetype"]["value"]["name"],
        :name         => fields["summary"]["value"],
        :description  => fields["description"]["value"],
        :requested_by => fields["reporter"]["value"]["displayName"]
      )
      issue.notes = get_notes(fields)
      
      return issue
    end
    
    private
        
    def bug_search_criteria
      jql = [
        "project = #{@jira_id}",
        "issuetype = Bug",
        "status = Open",
        "created >= #{Date.today - 30}"
      ].join(" AND ")
    end
    
    def self.default_params
      config = Config.new(:config_file => "config.yml")
      
      return {
        :os_username => config.jira.username,
        :os_password => config.jira.password
      }
    end
    
    def self.get_notes(fields)
      notes = []
      
      notes << get_environment(fields)
      notes << get_attachments(fields)
      notes << get_comments(fields)
      
      return notes.flatten
    end
    
    def self.get_environment(fields)
      environment = fields["environment"]["value"]
      environment_comment = "Environment: #{environment}" if !environment.nil?
      
      return environment_comment || []
    end
    
    def self.get_comments(fields)
      fields["comment"]["value"].collect do |comment|
        coder = HTMLEntities.new
        coder.decode(Sanitize.clean(comment["body"]))
      end
    end
    
    def self.get_attachments(fields)
      fields["attachment"]["value"].collect do |image|
        image["content"]
      end
    end
    
  end
end