## TODO

X * Fix error for status
X * Restrict to project
X * Get project id from command line
X * Don't import duplicate JIRA stories
X * Parse config.yml to get JIRA and Pivotal credentials

* Rename pivotaltracker executable to rtracker
* Parse XML from file to get list of stories
* Parse JSON for each story
* Get XML from JIRA

## Later

* Allow prompt for password for JIRA and Pivotal
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