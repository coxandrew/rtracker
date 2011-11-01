require "nokogiri"
require "pp"

module PivotalTracker
  class Story
    attr_reader :id, :name, :jira_id, :story_type

    def initialize(options = {})
      @id               = options["id"]
      @project_id       = options["project_id"]
      @story_type       = options["story_type"]
      @name             = options["name"]
      @description      = options["description"]
      @requested_by     = options["requested_by"]
      @current_state    = options["current_state"]
      @estimate = options["estimate"]
      @jira_id          = options["jira_id"].to_i if options["jira_id"]

      @notes = []
      jira_url_pattern = /^https?:\/\/jira.autodesk.com\/issues\/[0-9]{4,}$/
      options["notes"].to_a.each do |note|
        new_note = Note.new(note)
        if @jira_id.nil? && new_note.text =~ jira_url_pattern
          @jira_id = new_note.text.scan(/[0-9]+$/).first.to_i
        end
        @notes << new_note
      end
    end

    def to_xml
      Nokogiri::XML::Builder.new { |xml|
        xml.story {
          xml.story_type    @story_type
          xml.name          @name
          xml.requested_by  @requested_by
        }
      }.to_xml
    end

    def add
      conn = Connection.new
      response = conn.class.post(
        "/projects/#{@project_id}/stories",
        :headers => {
          "Content-type" => "application/xml",
          "X-TrackerToken" => conn.pivotal_token
        },
        :body => self.to_xml
      )
      set_id(response)
      puts "+ Added #{@story_type}: '#{@name}'"
    end

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
          "X-TrackerToken" => conn.pivotal_token
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

  end
end

