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
      
      stories = Project.new("id" => project_id).stories
      stories_imported = 0
      Jira.new.issues.each do |issue|
        story = Story.new(
          "project_id"      => project_id,
          "story_type"      => issue.story_type,
          "name"            => issue.name,
          "requested_by"    => issue.requested_by,
          "description"     => issue.description,
          "jira_id"         => issue.jira_id,
          "notes"           => issue.notes
        )
        story_exists = stories.find { |s| s.jira_id == story.jira_id }
        if story_exists
          @logger.debug "- Already imported JIRA issue: '[#{story.jira_id}] #{story.name}'"
        else
          story.add
          stories_imported += 1
          story.notes.each do |note|
            story.add_note(note)
          end
        end
      end
      
      @logger.info "JIRA: #{stories_imported} #{(stories_imported == 1) ? 'story' : 'stories'} imported"
    end

    def method_missing(sym, *args, &block)
      raise OptionParser::InvalidCommand
    end
  end
end