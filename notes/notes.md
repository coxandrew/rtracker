## TODO

X * Use correct JIRA query parameters
X * Schedule cron job to poll from FF and FFM

## Debugging

* Add integration id as config param
* Add logging level as a param
* For "info" level debugging, output the bugs that were returned from the JIRA query
* Update installation with fixed copy (no local changes)

## Later

* Use Jenkins for deploying to ~/bin/rtracker
* Get the right names for the comments
* Only log to stdout if verbose is set
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

## NOTES

Firefly Testing Sandbox: 369409
API Token: d16dddbdd03adf75eeca86e55e4031b5

Add a story with XML:

    curl -H "X-TrackerToken: d16dddbdd03adf75eeca86e55e4031b5" -X POST -H "Content-type: application/xml" -d "<story><story_type>feature</story_type><name>Fire torpedoes</name><requested_by>Andrew Cox</requested_by></story>" http://www.pivotaltracker.com/services/v3/projects/369409/stories

Add story with params (not working yet):

    curl -H "X-TrackerToken: d16dddbdd03adf75eeca86e55e4031b5" -X POST "http://www.pivotaltracker.com/services/v3/projects/369409/stories?story\[name\]=Make%20it%20so&story\[requested_by\]=Picard"

## Getting story sizes

## Questions

* Can you add a note when creating a story?