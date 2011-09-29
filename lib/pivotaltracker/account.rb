module PivotalTracker
  class Account
    def initialize
      @connection = Connection.new
    end

    def projects
      Project.all
    end

    def releases
      projects.collect do |project|
        project.releases
      end.flatten
    end

    def upcoming_deadlines
      releases_with_deadlines.select do |release|
        Date.parse(release["deadline"].to_s) >= Date.today
      end
    end

    private

    def releases_with_deadlines
      releases.select { |release| release["deadline"] }.sort_by do |release|
        Date.parse(release["deadline"].to_s)
      end
    end
  end
end
