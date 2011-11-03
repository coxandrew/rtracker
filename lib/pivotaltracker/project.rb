require "nokogiri"
require "csv"

module PivotalTracker
  class Project
    attr_reader :id, :name, :velocity

    def initialize(attributes)
      @connection = Connection.new
      @id         = attributes["id"]
      @name       = attributes["name"]
      @velocity   = attributes["current_velocity"]
    end
    
    def self.find(id)
      Connection.new.request("/projects/#{id}")
    end

    def self.all
      projects = Connection.new.request("/projects").parsed_response["projects"]
      projects.collect { |attributes| Project.new(attributes) }
    end

    def stories
      response = @connection.request("/projects/#{@id}/stories")
      response.parsed_response["stories"].collect { |s| Story.new(s) }
    end

    def accepted_stories
      stories.select { |story| story.accepted? }
    end

    def velocity
      response = @connection.request("/projects/#{@id}")
      if response["message"] == "Resource not found"
        raise "No project with id: #{@id}"
      end

      return response.parsed_response["project"]["current_velocity"]
    end

    def releases
      @connection.request("/projects/#{@id}/stories",
        :filter => "type:release").parsed_response["stories"]
    end

    def next_milestone
      releases.each do |release|
        if release["deadline"]
          return release if Date.parse(release["deadline"].to_s) >= Date.today
        end
      end
    end

    def stories_csv
      CSV.open("stories.csv", "wb") do |csv|
        accepted_stories.each do |story|
          csv << story.csv_fields if story.story_type == "feature"
        end
      end
    end
  end
end