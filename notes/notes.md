## TODO

X * Fix error for status
X * Restrict to project
X * Get project id from command line
X * Don't import duplicate JIRA stories
X * Parse config.yml to get JIRA and Pivotal credentials
X * Rename pivotaltracker executable to rtracker
X * Parse XML from file to get list of stories
X * Get XML from JIRA
X * Use username and password for JIRA from Yaml file 
X * Try using External Link for JIRA in Pivotal story

* Add screenshots as notes
* Add comments
* Try using mash from hashie for creating a proper Project object
* Get integration id from the Project
* Handle unknown users gracefully
* Make a proper Project object that you can use with `Project.find()`
* Try vcr for integration tests
* Delete all stories in setup for tests
* Make https work

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