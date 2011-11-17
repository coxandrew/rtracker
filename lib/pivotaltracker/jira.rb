require 'httpclient'
require 'uri'
require 'sanitize'
require 'htmlentities'
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
          :requested_by => node.xpath("reporter").text
        )
      
        issue.notes = get_notes(node)
        issues << issue
      end
      
      return issues
    end
    
    def xml_export
      jql_criteria = [
        # "project = FF",
        # "(summary ~ \"dwfs not translating\" OR description ~ \"dwfs not translating\")",
        # "status in (Open, \"In Progress\", Reopened)"        
        "project = FF",
        "summary = \"DWFs not translating\"",
        "issuetype = Bug",
        "status = Open"
        # project = FF AND summary ~ "\"dwfs not translating\"" AND issuetype = Bug AND status = Open
      ]
      # jql_query = jql_criteria.join(" AND ")
      jql_query = 'project = FF AND summary ~ "\"dwfs not translating\"" AND issuetype = Bug AND status = Open'
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
    
    private
    
    def get_notes(node)
      notes = []
    
      environment = node.xpath("environment")
      notes << "Environment: #{environment.text}" if !environment.text.empty?
    
      node.xpath("comments/comment[text()]").each do |comment|
        coder = HTMLEntities.new
        notes << coder.decode(Sanitize.clean(comment.text))
      end
      
      notes << get_attachments(node)
      
      return notes.flatten
    end
    
    def get_attachments(node)
      attachment_base_uri = "http://jira.autodesk.com/secure/attachment"
      attachments = []
      node.xpath("attachments/attachment").each do |image|
        path = "#{image.attribute("id")}/#{image.attribute("name")}"
        attachments << URI.escape("#{attachment_base_uri}/#{path}")
      end
      return attachments
    end
  end
end