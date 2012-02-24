require "spec_helper"

include PivotalTracker

describe Project do

  context "#project" do
    it "gets name and velocity for a project" do
      VCR.use_cassette('pt_Firefly_Testing_Sandbox') do
        project = Project.new(369409)
        project.name.should == "Firefly Testing Sandbox"
        project.velocity.should == "10"
      end
    end

    it "gets the integration id" do
      VCR.use_cassette('pt_Firefly_Testing_Sandbox') do
        project = Project.new(369409)
        project.integration_id.should == 9423
      end
    end
  end

  context "#stories" do
    it "gets all stories" do
      VCR.use_cassette('pt_stories') do
        project = Project.new(369409)
        project.stories
      end
    end
  end

  context "#accepted_stories" do
    it "gets all accepted stories" do
      VCR.use_cassette('pt_accepted_stories') do
        project = Project.new(369409)
        project.accepted_stories
      end
    end
  end

  context "#stories_csv" do
    it "outputs stories in CSV format" do
      VCR.use_cassette('pt_csv') do
        project = Project.new(369409)
        project.stories_csv
      end
    end
  end

  context "#members" do
    VCR.use_cassette('pt_members') do
      project = Project.new(369409)
      project.members
    end
  end

  context "#owners" do
    VCR.use_cassette('pt_owners') do
      project = Project.new(369409)
    end
  end

end