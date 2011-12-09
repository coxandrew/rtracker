require 'nokogiri'
require 'pp'
require 'sanitize'
require 'logging'

module PivotalTracker
  class Story
    attr_reader :id, :name, :jira_id, :story_type, :notes

    def initialize(options = {})
      @config           = Config.new
      
      @id               = options["id"]
      @project_id       = options["project_id"]
      @story_type       = options["story_type"]
      @name             = options["name"]
      @description      = Sanitize.clean(options["description"])
      @requested_by     = "Andrew Cox" # options["requested_by"]
      @current_state    = options["current_state"]
      @estimate         = options["estimate"]
      @jira_id          = options["jira_id"] || options["other_id"]
      @notes            = options["notes"]
    end
    
    def self.from_jira(project_id, issue)
      Story.new(
        "project_id"      => project_id,
        "story_type"      => issue.story_type.downcase,
        "name"            => issue.name,
        "requested_by"    => issue.requested_by,
        "description"     => issue.description,
        "jira_id"         => issue.jira_id,
        "notes"           => issue.notes
      )
    end

    def to_xml
      Nokogiri::XML::Builder.new { |xml|
        xml.story {
          xml.story_type      @story_type
          xml.name            @name
          xml.description     @description
          xml.requested_by    @requested_by
          
          # JIRA integration
          xml.other_id        @jira_id
          xml.integration_id  @config.pivotal.integration_id
        }
      }.to_xml
    end

    # TODO: Don't reach through Connection to get the pivotal token
    def add
      conn = Connection.new
      response = conn.class.post(
        "/projects/#{@project_id}/stories",
        :headers => {
          "Content-type" => "application/xml",
          "X-TrackerToken" => conn.config.pivotal.token
        },
        :body => self.to_xml
      )
      set_id(response)
      PivotalTracker.logger.info "+ Added #{@story_type}: '#{@name}'"
    end

    # TODO: Don't reach through Connection to get the pivotal token
    def add_note(note)
      conn = Connection.new
      path = "/projects/#{@project_id}/stories/#{@id}/notes"

      note_xml = Nokogiri::XML::Builder.new { |xml|
        xml.note {
          xml.text_ note
        }
      }.to_xml

      conn.class.post(
        path,
        :headers => {
          "Content-type" => "application/xml",
          "X-TrackerToken" => conn.config.pivotal.token
        },
        :body => note_xml
      )
    end

    def set_id(httparty_response)
      @id = httparty_response["story"]["id"]
    end

    def accepted?
      @current_state == "accepted"
    end

    def csv_fields
      [@name, @story_type, @estimate]
    end

    def self.story_type(node)
      story_type = node.xpath("type").text.scan(/^(feature|bug)/i)[0]
      story_type ||= ["feature"]
      story_type.first.downcase
    end

  end
end
