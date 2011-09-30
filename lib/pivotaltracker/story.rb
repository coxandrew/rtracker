require "nokogiri"

module PivotalTracker
  class Story
    attr_reader :id, :name

    def initialize(options = {})
      @id               = options["id"]
      @project_id       = options["project_id"]
      @story_type       = options["story_type"]
      @name             = options["name"]
      @description      = options["description"]
      @requested_by     = options["requested_by"]
      @current_state    = options["current_state"]
      @current_estimate = options["current_estimate"]

      @jira_id          = options["jira_id"]
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
      puts "Adding story #{@name} ..."
      conn = Connection.new
      response = conn.class.post(
        "/projects/#{@project_id}/stories",
        :headers => {
          "Content-type" => "application/xml",
          "X-TrackerToken" => conn.token
        },
        :body => self.to_xml
      )
      set_id(response)
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
          "X-TrackerToken" => conn.token
        },
        :body => note_xml
      )
    end

    def set_id(httparty_response)
      @id = httparty_response["story"]["id"]
    end

  end
end

