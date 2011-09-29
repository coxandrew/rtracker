require 'spec_helper'

include PivotalTracker

describe Printer do
  let(:output)   { double('output').as_null_object }
  let(:printer)  { Printer.new(output) }

  context "#print_status" do
    let(:projects) { Account.new.projects }

    it "prints all active projects" do
      output.should_receive(:print).with(/My Sample Project/)
      output.should_receive(:print).with(/Secret Project/)

      printer.print_status(projects)
    end

    it "prints next deadlines for each project" do
      output.should_receive(:print).with(/2011-01-30/)
      output.should_receive(:print).with(/2011-02-05/)

      printer.print_status(projects)
    end
  end

  context "#print_deadlines" do
    let(:releases) { Account.new.upcoming_deadlines }

    it "lists all upcoming deadlines" do
      output.should_receive(:print).with(/2011-01-30/)
      output.should_receive(:print).with(/2011-02-05/)
      output.should_receive(:print).with(/2011-02-28/)

      printer.print_deadlines(releases)
    end
  end
end