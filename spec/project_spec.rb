require 'spec_helper'

include PivotalTracker

describe Project do
  context "#stories" do
    it "gets all stories" do
      project = Project.new("id" => "369409")
      pp project.stories
    end
  end
end