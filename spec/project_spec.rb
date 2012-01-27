require 'spec_helper'
require 'pp'

include PivotalTracker

describe Project do
  context "#project" do
    it "finds a single project by id" do
      VCR.use_cassette('pt_398325') do
        Project.find(398325)
      end
    end
  end
  
  context "#stories" do
    it "gets all stories" do
      VCR.use_cassette('pt_stories') do
        project = Project.new("id" => "369409")
        project.stories
      end
    end
  end

  context "#accepted_stories" do
    it "gets all accepted stories" do
      VCR.use_cassette('pt_accepted_stories') do
        project = Project.new("id" => "369409")
        project.accepted_stories
      end
    end
  end

  context "#stories_csv" do
    it "outputs stories in CSV format" do
      VCR.use_cassette('pt_csv') do
        project = Project.new("id" => "331671")
        project.stories_csv
      end
    end
  end
  
  context "#members" do
    VCR.use_cassette('pt_members') do
      project = Project.new("id" => "369409")
      project.members
    end
  end
  
  context "#owners" do
    VCR.use_cassette('pt_owners') do
      project = Project.new("id" => "369409")
    end
  end
  
end