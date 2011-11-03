require 'spec_helper'
require 'pp'

include PivotalTracker

describe Jira do
  it "gets the JIRA config credentials" do
    jira = Jira.new("config.yml.example")
    jira.username.should == "your_username"
    jira.password.should == "Password1"
    jira.base_uri.should == "jira.yourcompany.com"
  end
  
  context "integration testing" do
    it "gets an XML export of issues" do
      jira = Jira.new
      jira.xml_export
    end
  end
end
