require 'spec_helper'

include PivotalTracker

describe Command do
  context "#import" do
    it "imports stories from a JIRA project into Pivotal project" do
      cmd = Command.new
      cmd.import(:jira_id => "FF", :id => "369409")
    end
  end
end