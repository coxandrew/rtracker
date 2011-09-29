module PivotalTracker
  class Printer
    def initialize(output)
      @output = output
    end

    def print_status(projects)
      column_widths = [10, 30, 10, 13]
      print_status_header(column_widths)

      projects.each { |project| print_project_status(project, column_widths) }
    end

    def print_deadlines(releases)
      column_widths = [12, 30]
      print_deadlines_header(column_widths)

      releases.each { |release| print_deadline(release) }
    end

    def print_velocity(velocity)
      @output.puts velocity
    end

    private

    def short_date(date)
      date.strftime("%Y-%m-%d")
    end

    def print_deadlines_header(column_widths)
      @output.puts ""
      @output.print "date".ljust(column_widths[0])
      @output.print "deadline".ljust(column_widths[1])
      @output.puts ""
      header_width = column_widths.inject { |sum, value| sum += value }
      header_width.times { |num| @output.print "-" }

      @output.puts ""
    end

    def print_status_header(column_widths)
      @output.puts ""
      @output.print "id".ljust(column_widths[0])
      @output.print "project".ljust(column_widths[1])
      @output.print "velocity".ljust(column_widths[2])
      @output.print "next deadline".ljust(column_widths[3])
      @output.puts ""
      header_width = column_widths.inject { |sum, value| sum += value }
      header_width.times { |num| @output.print "-" }

      @output.puts ""
    end

    def print_project_status(project, column_widths)
      @output.print project.id.ljust(column_widths[0])
      @output.print project.name.ljust(column_widths[1])
      @output.print project.velocity.ljust(column_widths[2])

      next_milestone = project.next_milestone
      if next_milestone.length > 0
        deadline = short_date(Date.parse(next_milestone["deadline"].to_s))
        @output.print "#{deadline}".ljust(column_widths[3])
      else
        @output.print "NONE"
      end

      @output.puts ""
    end

    def print_deadline(release)
      deadline = Date.parse(release["deadline"].to_s)

      @output.print short_date(deadline)
      @output.print "  "
      @output.print release["name"]
      @output.puts ""
    end
  end
end