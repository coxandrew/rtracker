## Overview

A Ruby command-line wrapper for the [PivotalTracker](http://pivotaltracker.com) API that allows you to:

* Report on overall health of projects
* Import issues from JIRA

## Setup

Copy config.yaml.example to config.yaml and change to match your project:

    pivotal:
      api_key: a87lksdf9a87dsf98asdfjasd89f7sdf
    jira:
      domain: jira.autodesk.com
      username: your_username
      password: Password1

## Usage

Show high-level RED/YELLOW/GREEN status of all projects

    $ pt status

    id        project              status   schedule       next deadline
    --------------------------------------------------------------------
    166983    IO Pro Maintenance   GREEN    5 days ahead   2011-01-20
    166979    Scrapple             YELLOW   1 day behind   2011-01-20

Show detailed status of a single project

    $ pivotaltracker status --project 166983

    NAME:
      IO Pro Maintenance

    NEXT DEADLINE:
      2011-01-20 - Velocity 8.0-3 Code Complete

    SCHEDULE:
      5 days ahead

    VELOCITY:
      10 story points

Show current velocity of a given project

    $ pivotaltracker velocity --project 331671

    10 story points / week

Show the current velocity of the UX team

    $ pivotaltracker velocity --team ux

    14 story points / week

List the upcoming deadlines

    $ pivotaltracker deadlines

    2011-01-20 - Velocity 8.0-3 Code Complete
    2011-01-31 - Velocity 8.0-3 Last Possible Change

Import all issues from a JIRA project into a Pivotal project:

    $ pivotaltracker import --jira FFM --project 331671

## References

* [PivotalTracker API v3 Reference]([https://www.pivotaltracker.com/help/api?version=v3)
