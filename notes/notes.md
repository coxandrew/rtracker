## TODO

X * Set up RSpec
X * Swap out Nokogiri for hpricot
X * Get list of projects with their IDs
X * Get next deadline for a given project by ID
X * Add command-line options for 'help', 'status'
X * 'deadlines' command

## MORNING

X * Add a whitelist of available commands
X * Refactor to separate interface from model

## PEER REVIEW

X * Remove LOAD_PATH in favor of running with `ruby -Ilib`
X * Don't misuse the bang method convention
* Look into duplication in Account#upcoming_deadlines and Project#next_milestone
* Use StringIO for testing Printer
* Look into ncurses for printing columns

## LATER

* Mock out accounts for printer spec so we don't have to hit the server
* Add specs for:
  * account
  * project
  * connection
  * command
* Determine RED/GREEN/YELLOW status of a project based on deadline
* 'velocity' command
* Add team-based calculations for Velocity
  * Hard-coded list of projects
  * Read from YAML file

## QUESTIONS

* More elegant way of calculating column widths?