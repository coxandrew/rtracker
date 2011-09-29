## Overview

This is a library to take import issues from JIRA into a Pivotal project.

## Setup

Copy config.yaml.example to config.yaml and change to match your project:

    domain:   jira.autodesk.com
    jira_username: root
    jira_password: secret_password

## Usage

Import all issues from a JIRA project into a Pivotal project:

    $ jpivot --jira FFM --pivotal 331671

## NOTES

Firefly Testing Sandbox: 369409
API Token: d16dddbdd03adf75eeca86e55e4031b5