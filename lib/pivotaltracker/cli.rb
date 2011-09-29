require 'optparse'
require 'ostruct'

module PivotalTracker
  class OptionParser::TooManyCommands < Exception; end

  class Cli
    def initialize(args)
      @args = args
    end

    def run
      begin
        options = parse(@args)

        raise OptionParser::TooManyCommands if @args.length > 1
        if @args.length == 1
          command = Command.new
          command.send(@args.first, options)
        elsif !options[:help]
          parse(["--help"])
        end
      rescue OptionParser::InvalidCommand
        puts "\nInvalid command"
        parse(["--help"])
      rescue OptionParser::InvalidOption
        puts "\nInvalid option"
        parse(["--help"])
      rescue OptionParser::TooManyCommands
        puts "\nToo many commands"
        parse(["--help"])
      end
    end

    private

    def parse(args)
      options = {}

      optparse = OptionParser.new do |opts|
        opts.banner = "\nusage: pivotaltracker [OPTIONS] <command>"

        opts.separator("")
        opts.separator("options:")

        opts.on("-h", "--help", "Print this help") do
          options[:help] = true
          puts opts
          print_available_commands
        end

        opts.on("-p", "--project PROJECT_ID",
          "Limit command to a specific PROJECT_ID") do |project_id|
          options["id"] = project_id
        end

      end

      optparse.parse!(args)
      return options
    end

    def print_available_commands
      puts "\ncommands:"

      available_commands.each do |command|
        print "    #{command.keyword.ljust(33)}"
        print command.description
        puts ""
      end
    end

    def available_commands
      commands = []
      commands << OpenStruct.new(
        :keyword => "status",
        :description => "Show the high-level status of all projects"
      )
      commands << OpenStruct.new(
        :keyword => "deadlines",
        :description => "List the upcoming deadlines for for all projects"
      )
      commands << OpenStruct.new(
        :keyword => "velocity",
        :description => "With the --project option, show the velocity of a project"
      )
      return commands
    end
  end
end