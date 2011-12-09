## TODO

X * Use correct JIRA query parameters
X * Schedule cron job to poll from FF and FFM

## Debugging

* Add JIRA project ID to config file for a default value
* Add integration id as config param
* Add logging level as a param
* For "info" level debugging, output the bugs that were returned from the JIRA query

## Next

* Update installation with fixed copy (no local changes)

## Later

* Get the right names for the comments
* Use Jenkins for deploying to ~/bin/rtracker
* Optimize for number of API calls
* Add "mobile" or "web" labels depending on JIRA project?
* Handle unknown users gracefully
* Get integration id from the Project
* Try using mash from hashie for creating a proper Project object
* Make a proper Project object that you can use with `Project.find()`
* Try vcr for integration tests
* Delete all stories in setup for tests
* Is there a cleaner way to get notes without having to flatten?
* Make https work
* Error handling for import without a jira_id

## Questions

* Can you add a note when creating a story?