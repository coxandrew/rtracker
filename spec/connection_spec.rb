require 'spec_helper'

include PivotalTracker

describe Connection do
  context "#initialize" do
    it "gets pivotal token" do
      conn = Connection.new("config.yml.example")
      conn.config.pivotal.token.should == "a87lksdf9a87dsf98asdfjasd89f7sdf"
    end
  end
end