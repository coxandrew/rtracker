module PivotalTracker
  class OptionParser::InvalidCommand < Exception; end

  class Command
    def initialize
      @account = Account.new
      @printer = Printer.new(STDOUT)
    end

    def status(options = {})
      @printer.print_status(@account.projects)
    end

    def deadlines(options = {})
      @printer.print_deadlines(@account.upcoming_deadlines)
    end

    def velocity(options = {})
      project = Project.new(options)
      @printer.print_velocity(project.velocity)
    end

    def method_missing(sym, *args, &block)
      raise OptionParser::InvalidCommand
    end
  end
end