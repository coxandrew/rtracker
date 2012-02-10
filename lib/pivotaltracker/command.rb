require 'nokogiri'
require 'pp'
require 'pivotaltracker/logging'

module PivotalTracker
  class OptionParser::InvalidCommand < Exception; end

  class Command
    def initialize
      @account = Account.new
      @printer = Printer.new(STDOUT)
      @logger = PivotalTracker.logger
    end

    def status(options = {})
      projects = @account.projects
      if options["id"]
        projects.select! { |project| project.id == options["id"] }
      end

      @printer.print_status(projects)
    end

    def deadlines(options = {})
      @printer.print_deadlines(@account.upcoming_deadlines)
    end

    def velocity(options = {})
      project = Project.new(options)
      @printer.print_velocity(project.velocity)
    end

    # TODO: Move command exceptions to cli?
    def import(options = {})
      project_id = options["id"]
      if project_id.nil?
        $stderr.puts "\nError: import requires a --project argument"
        raise OptionParser::InvalidOption
      end

      stories = Project.new(project_id).stories
      stories_imported = 0
      Jira.new(options).bugs.each do |issue|
        story_exists = stories.find { |s| s.jira_id == issue.jira_id }
        if story_exists
          @logger.debug "- Already imported JIRA issue: #{issue.jira_id}"
        else
          issue = Jira.find(issue.jira_id)
          story = Story.from_jira(project_id, issue)
          story.add
          stories_imported += 1
          story.notes.each { |note| story.add_note(note) }
        end
      end

      @logger.info "JIRA: #{stories_imported} #{(stories_imported == 1) ? 'story' : 'stories'} imported"
    end

    def method_missing(sym, *args, &block)
      raise OptionParser::InvalidCommand
    end
  end
end