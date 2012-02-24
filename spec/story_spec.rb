require 'spec_helper'

include PivotalTracker

describe Story do
  context "#find" do
    it "gets an XML representation of a story from a project and story id" do
      VCR.use_cassette('pt_story_369409') do
        story = Story.find(:project_id => 369409, :story_id => 24790881)
      end
    end
  end
end