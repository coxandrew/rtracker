require "nokogiri"

module PivotalTracker
  class Story
    def initialize(options = {})
      @jira_id      = options[:jira_id]
      @story_type   = options[:story_type]
      @name         = options[:name]
      @requested_by = options[:requested_by]
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
  end
end