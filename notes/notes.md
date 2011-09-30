## TODO

X * Fix error for status
X * Restrict to project

* Add "import" command
* Read config settings from YAML file
* Make https work

## Later

* Allow prompt for password for JIRA and Pivotal

## NOTES

Firefly Testing Sandbox: 369409
API Token: d16dddbdd03adf75eeca86e55e4031b5

Add a story with XML:

    curl -H "X-TrackerToken: d16dddbdd03adf75eeca86e55e4031b5" -X POST -H "Content-type: application/xml" -d "<story><story_type>feature</story_type><name>Fire torpedoes</name><requested_by>Andrew Cox</requested_by></story>" http://www.pivotaltracker.com/services/v3/projects/369409/stories

Add story with params (not working yet):

    curl -H "X-TrackerToken: d16dddbdd03adf75eeca86e55e4031b5" -X POST "http://www.pivotaltracker.com/services/v3/projects/369409/stories?story\[name\]=Make%20it%20so&story\[requested_by\]=Picard"

## Questions

* Can you add a note when creating a story?