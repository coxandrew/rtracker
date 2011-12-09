require 'spec_helper'
require 'pp'

include PivotalTracker

describe Jira do
  it "gets the JIRA config credentials" do
    jira = Jira.new(:config_file => "config.yml.example")
  end
  
  context "#bugs" do
    it "gets the bugs from the last 30 days" do
      jira = Jira.new("jira_id" => "FFM")
      jira.bugs.size.should be > 1
    end
  end
  
  context ".find" do
    it "gets an issue given a JIRA issue id" do
      bug = Jira.find("FFM-257")
      bug.name.should == "Raster on Dilbert's house sheet 2 displays incorrectly"
    end
    
    it "adds the environment as a note" do
      bug = Jira.find("FFM-257")
      bug.notes.should include("Environment: Galaxy Tab 10.1, Kindle Fire")
    end
    
    it "shouldn't add a note if no environment is set" do
      bug = Jira.find("FFM-254")
      
      bug.notes.each do |note|
        note.should_not match(/^Environment: /)
      end
    end
    
    it "adds comments as notes" do
      bug = Jira.find("FFM-254")
      bug.notes.size.should == 3
      bug.notes.first.should match /^The problem is being caused by/
    end
    
    it "adds attachments as notes with links to the files" do
      bug = Jira.find("FFM-257")
      bug.notes[1].should == "http://jira.autodesk.com/secure/attachment/94346/device-2011-12-06-093716.png"
      bug.notes[2].should == "http://jira.autodesk.com/secure/attachment/94347/Dilbert+Ultimate+House+Project.dwf"
    end
  end
end
