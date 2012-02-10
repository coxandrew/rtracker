require "nokogiri"
require "csv"
require 'pp'

module PivotalTracker
  class Project
    attr_reader :id, :name, :velocity, :integration_id

    def initialize(project_id)
      @connection = Connection.new
      @id         = project_id

      set_project_details
    end

    def self.all
      projects = Connection.new.request("/projects").parsed_response["projects"]
      projects.collect { |attributes| Project.new(attributes) }
    end

    def members
      @connection.request("/projects/#{@id}/memberships")["memberships"]
    end

    def owners
      members.select do |member|
        member["role"] == "Owner"
      end
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

    private

    def set_project_details
      response = @connection.request("/projects/#{@id}")
      project = response.parsed_response["project"]

      @name           = project["name"]
      @velocity       = project["current_velocity"]
      @integration_id = project["integrations"][0]["id"]
    end

  end
end