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
      puts "Importing.."

      # TODO: If there's not a single project, throw exception
      project_id = "369409"
      project = Project.new("id" => project_id)

      # TODO:
      # For each issue:
      # * Get list of issues from JIRA
      # * Parse list of issues into array of issue objects
      # * Check to see if that issue is in Pivotal
      # * If not, add it
      # * Add notes for:
      #   * JIRA URL
      #   * Attachments
      # * If it's in Pivotal, add any new comments, attachments, etc

      issues = []
      issues << OpenStruct.new(
        :jira_id => "1234",
        :story_type => "bug",
        :name => "New bug from cli (#{Time.now})",
        :requested_by => "Andrew Cox"
      )
      issues << OpenStruct.new(
        :jira_id => "1235",
        :story_type => "feature",
        :name => "New feature from cli (#{Time.now})",
        :requested_by => "Andrew Cox",
        :note => "Example note"
      )

      issues.each do |issue|
        story = Story.new(
          "project_id" =>     project_id,
          "story_type" =>     issue.story_type,
          "name" =>           issue.name,
          "requested_by" =>   issue.requested_by,
          "note" =>           issue.note,
          "jira_id" =>        issue.jira_id
        )
        story.add
        story.add_note("http://jira.autodesk.com/issues/#{issue.jira_id}")
      end
    end

    def method_missing(sym, *args, &block)
      raise OptionParser::InvalidCommand
    end
  end
end