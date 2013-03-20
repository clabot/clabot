'use strict'

crypto = require 'crypto'

_ = require 'lodash'

answerComment     = require './answerComment'
answerPullRequest = require './answerPullRequest'

exports.notify = (req, res) ->
  options = req.clabotOptions
  payload = JSON.parse req.body.payload

  repo   = payload.repository.name
  user   = payload.repository.owner.login

  secret = options.secrets?[user]?[repo] or ''

  unless req.rawBody and hubSignature = req.get 'X-Hub-Signature'
    console.log   'Fatal Error: Can not trust request without raw body'
    res.send 500, 'Fatal Error: Can not trust request without raw body'
    return

  payloadSignature = 'sha1=' + crypto
    .createHmac('sha1', secret)
    .update(req.rawBody)
    .digest('hex')

  delete req.rawBody

  if hubSignature isnt payloadSignature
    console.log   'Fatal Error: Untrusted source'
    res.send 500, 'Fatal Error: Untrusted source'
    return

  if _.isFunction options.getContractors
    options.getContractors (contractors) ->

      if payload.pull_request and payload.action is 'opened'
        answerPullRequest req, res, options, contractors, payload
      else if payload.comment and
              payload.issue.pull_request and
              payload.action is 'created'
        answerComment req, res, options, contractors, payload
      else
        console.log   'Unexpected event. I\'ll just pretend nothing happened'
        res.send 200, 'Unexpected event. I\'ll just pretend nothing happened'

  else
    console.log   'Fatal Error: options#getContractors not provided'
    res.send 500, 'Fatal Error: options#getContractors not provided'

exports.default = (req, res) ->
  res.send 'always at your service, clabot'
