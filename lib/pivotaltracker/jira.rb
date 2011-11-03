require 'httpclient'
require 'pp'

module PivotalTracker
  class Jira
    attr_accessor :username, :password, :base_uri
    
    def initialize(config_file = "config.yml")
      config = Config.new(config_file)
      @username = config.jira.username
      @password = config.jira.password
      @base_uri = config.jira.base_uri
    end
    
    def issues(options = {})
      issues = []
      Nokogiri::XML(xml_export).xpath("//item").each do |node|
        issue = OpenStruct.new(
          :jira_id      => node.xpath("key").text,
          :story_type   => Story.story_type(node),
          :name         => node.xpath("summary").text,
          :description  => node.xpath("description").text,
          :requested_by => "Andrew Cox" # node.xpath("reporter").text
        )
      
        issue.notes = []
      
        environment = node.xpath("environment")
        if !environment.text.empty?
          issue.notes << "Environment: #{environment.text}"
        end
      
        node.xpath("comments/comment[text()]").each do |comment|
          issue.notes << comment.text
        end
      
        issues << issue
      end
      
      return issues
    end
    
    def xml_export
      jql_criteria = [
        "project = FF",
        "status in (Open, \"In Progress\", Reopened)"
      ]
      jql_query = jql_criteria.join(" AND ")
      query = {
        :jqlQuery => jql_query,
        :tempMax => "5",
        :os_username => @username,
        :os_password => @password
      }
      
      path = "http://" + @base_uri +
        "/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml"
      response = HTTPClient.get(path, :query => query)
      
      return response.content
    end
  end
end