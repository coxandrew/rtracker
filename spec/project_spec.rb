require 'spec_helper'
require 'pp'

include PivotalTracker

describe Project do
  context "#project" do
    it "finds a single project by id" do
      project = Project.find(369409)
    end
  end
  
  context "#stories" do
    it "gets all stories" do
      project = Project.new("id" => "369409")
      project.stories
    end
  end

  context "#accepted_stories" do
    it "gets all accepted stories" do
      project = Project.new("id" => "369409")
      project.accepted_stories
    end
  end

  context "#stories_csv" do
    # Projects
    # 330951 - Firefly Mobile
    # 331671 - Firefly Web

    it "outputs stories in CSV format" do
      project = Project.new("id" => "331671")
      project.stories_csv
    end
  end
end