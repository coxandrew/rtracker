require 'spec_helper'

include PivotalTracker

describe Command do
  context "#import" do
    it "imports stories from a JIRA project into Pivotal project" do
      pending
      cmd = Command.new
      cmd.import("id" => "369409", "jira_id" => "FFM")
    end
  end
end
