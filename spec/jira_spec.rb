require 'spec_helper'

include PivotalTracker

describe Jira do
  it "gets the JIRA config credentials" do
    jira = Jira.new(:config_file => "config.yml.example")
  end

  context "#bugs" do
    it "gets the bugs from the last 30 days" do
      VCR.use_cassette('ffm_bugs') do
        jira = Jira.new("jira_id" => "FFM")
        jira.bugs.size.should == 17
      end
    end
  end

  context ".find" do
    it "gets an issue given a JIRA issue id" do
      VCR.use_cassette('jira_issue_257') do
        bug = Jira.find("FFM-257")
        bug.name.should == "Raster on Dilbert's house sheet 2 displays incorrectly"
      end
    end

    it "adds the environment as a note" do
      VCR.use_cassette('jira_issue_257') do
        bug = Jira.find("FFM-257")
        bug.notes.should include("Environment: Galaxy Tab 10.1, Kindle Fire")
      end
    end

    it "shouldn't add a note if no environment is set" do
      VCR.use_cassette('jira_issue_254') do
        bug = Jira.find("FFM-254")

        bug.notes.each do |note|
          note.should_not match(/^Environment: /)
        end
      end
    end

    it "adds comments as notes" do
      VCR.use_cassette('jira_issue_254') do
        bug = Jira.find("FFM-254")
        bug.notes.size.should == 3
        bug.notes.first.should match /^The problem is being caused by/
      end
    end

    it "adds attachments as notes with links to the files" do
      VCR.use_cassette('jira_issue_257') do
        bug = Jira.find("FFM-257")
        bug.notes[1].should == "http://jira.autodesk.com/secure/attachment/94346/device-2011-12-06-093716.png"
        bug.notes[2].should == "http://jira.autodesk.com/secure/attachment/94347/Dilbert+Ultimate+House+Project.dwf"
      end
    end
  end
end
