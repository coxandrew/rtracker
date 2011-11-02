require 'nokogiri'
require "pp"

module PivotalTracker
  class OptionParser::InvalidCommand < Exception; end

  class Command
    def initialize
      @account = Account.new
      @printer = Printer.new(STDOUT)
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

    def import(options = {})
      project_id = options["id"]
      if project_id.nil?
        $stderr.puts "\nError: import requires a --project argument"
        raise OptionParser::InvalidOption
      end

      # TODO:
      # For each issue:
      # * Get list of issues from JIRA
      # X * Parse list of issues into array of issue objects
      # X * Check to see if that issue is in Pivotal
      # X * If not, add it
      # * Add notes for:
      #   X * JIRA URL
      #   * Attachments
      # * If it's already in Pivotal, add any new comments, attachments, etc
      # * See if we can use "other integration" with the API

      issues = []
      jira_issues = Nokogiri::XML(File.open("fixtures/ff_jira_issues.xml"))
      jira_issues.xpath("//item").each do |node|
        issue = OpenStruct.new(
          :jira_id      => node.xpath("key").text,
          :story_type   => Story.story_type(node),
          :name         => node.xpath("summary").text,
          :requested_by => "Andrew Cox" # node.xpath("reporter").text
        )

        issue.notes = []

        environment = node.xpath("environment")
        if !environment.text.empty?
          issue.notes << "Environment: #{environment.text}"
        end

        node.xpath("comments/comment[text()]").each do |comment|
          issue.notes << comment.text
        end

        issues << issue
      end

      existing_stories = Project.new("id" => project_id).stories
      issues.each do |issue|
        story = Story.new(
          "project_id"      => project_id,
          "story_type"      => issue.story_type,
          "name"            => issue.name,
          "requested_by"    => issue.requested_by,
          "note"            => issue.note,
          "jira_id"         => issue.jira_id
        )
        if !existing_stories.find { |es| es.jira_id == story.jira_id }
          story.add
          story.add_note("http://jira.autodesk.com/issues/#{issue.jira_id}")
        else
          puts "- Already imported JIRA issue: '#{story.name}'"
        end
      end
    end

    def method_missing(sym, *args, &block)
      raise OptionParser::InvalidCommand
    end
  end
end