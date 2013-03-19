'use strict'

pullRequest = require '../src/lib/pull-request'

sample      = require './fixtures/pull-request-payload'

exports.pullRequest =
  getSender: (test) ->
    test.expect 1
    sender = pullRequest.getSender sample
    test.equal 'boennemann', sender, 'Got Sender'
    test.done()

  getData: (test) ->
    test.expect 1
    data = pullRequest.getData sample
    expected =
      user: 'clabot'
      repo: 'sandbox'
      number: 3
    test.deepEqual expected, data, 'Got Data'
    test.done()