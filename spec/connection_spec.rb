require 'spec_helper'

include PivotalTracker

describe Connection do
  context "#initialize" do
    it "gets credentials for jira and pivotal" do
      conn = Connection.new("config.yml.example")
      conn.jira_username.should == "your_username"
      conn.jira_password.should == "Password1"
      conn.pivotal_token.should == "a87lksdf9a87dsf98asdfjasd89f7sdf"
    end
  end
end