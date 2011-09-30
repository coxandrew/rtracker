require 'spec_helper'

include PivotalTracker

describe Command do
  context "#import" do
    it "reads in stories from JIRA" do
      cmd = Command.new
      cmd.import(:jira_id => "FF")
    end
  end
end