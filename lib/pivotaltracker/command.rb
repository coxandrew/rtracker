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
      project = Project.new("id" => "369409")

      # TODO:
      # For each issue:
      # * Check to see if that issue is in Pivotal
      # * If not, add it

      #
      # issues = [
      #         {
      #           :id => "foo",
      #           }
      #       ]

      story = Story.new(
        :story_type => "feature",
        :name => "New story from cli (#{Time.now})",
        :requested_by => "Andrew Cox"
      )
      project.add_story(story)
    end

    def method_missing(sym, *args, &block)
      raise OptionParser::InvalidCommand
    end
  end
end