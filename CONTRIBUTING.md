# Contributing to Trestle

## Table of Contents

1. [Running the Test Suite](#running-the-test-suite)
2. [Sandbox Application](#sandbox-application)
3. [Contributor License Agreement](#contributor-license-agreement)


## Running the Test Suite

After checking out the repository and installing dependencies by running `bundle`, the full RSpec test suite can be run with:

```sh
$ bundle exec rake
```

When submitting a pull request, please ensure that all of the tests are passing. Builds will be automatically checked for a passing test suite by [GitHub Actions](https://github.com/TrestleAdmin/trestle/actions).


## Sandbox Application

The Trestle repo includes a sandbox application with some example admins and pages to demo most of the available functionality.

The following commands will set up the database (including sample seed data) and start a rails server:

```sh
$ cd sandbox
$ bundle exec rails db:setup
$ bundle exec rails server
```

You can then browse to http://localhost:3000/admin to access the sandbox.


## Contributor License Agreement

We ask that all contributors please sign the [Contributor License Agreement](https://cla-assistant.io/TrestleAdmin/trestle). If you have not previously signed the agreement, you will be prompted to when creating your first pull request.
