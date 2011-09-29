## Overview

A command-line tool that uses the data and API from [PivotalTracker](http://pivotaltracker.com) to report on overall health of projects.

## Motivation

[PivotalTracker](http://pivotaltracker.com) provides a great way to determine an individual project's velocity and estimate for completing target releases, but does not provide a good overall view or team-based calculations.

My company would also like to be able to represent a high-level overview of all active projects in an easy-to-digest "status" or "radiator" web page. This CLI tool would be a nice stepping stone for creating that view.

## Usage

    # Show high-level RED/YELLOW/GREEN status of all projects
    $ pt status

    id        project              status   schedule       next deadline
    --------------------------------------------------------------------
    166983    IO Pro Maintenance   GREEN    5 days ahead   2011-01-20
    166979    Scrapple             YELLOW   1 day behind   2011-01-20

    # Show detailed status of a single project
    $ pivotaltracker status --project 166983

    NAME:
      IO Pro Maintenance

    NEXT DEADLINE:
      2011-01-20 - Velocity 8.0-3 Code Complete

    SCHEDULE:
      5 days ahead

    VELOCITY:
      10 story points

    # Show current velocity of a given project
    $ pivotaltracker velocity --project Scrapple

    10 story points / week

    # Show the current velocity of the UX team
    $ pivotaltracker velocity --team ux

    14 story points / week

    # List the upcoming deadlines
    $ pivotaltracker deadlines

    2011-01-20 - Velocity 8.0-3 Code Complete
    2011-01-31 - Velocity 8.0-3 Last Possible Change

## Notes

PivotalTracker does not support the concept of teams. To support team-based calculations, you will need to supply a YAML file that lists the team responsible for each project. For example:

    UX:
      projects: 166983, 166979, 155865
    Core:
      projects: 148721, 145817

## References

* [PivotalTracker API Reference]([https://www.pivotaltracker.com/help/api?version=v3)