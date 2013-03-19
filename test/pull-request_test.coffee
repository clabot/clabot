'use strict'

pullRequest = require '../src/lib/pull-request'
sample      = require './fixtures/pull-request-payload'

exports.pullRequest =
  getData: (test) ->
    test.expect 1
    data = pullRequest.getData sample
    expected =
      user: 'clabot'
      repo: 'sandbox'
      number: 3
    test.deepEqual expected, data, 'Got Data'
    test.done()
