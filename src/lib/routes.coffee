'use strict'

crypto = require 'crypto'

_ = require 'lodash'

comment  = require './comment'
skip     = require './skip'

exports.notify = (req, res) ->
  options = req.clabotOptions
  payload = JSON.parse req.body.payload

  number = payload.number
  repo   = payload.repository.name
  sender = payload.sender.login
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

  handleComment = (contractors) ->
    signed = _.contains contractors, sender

    commentData      = { user, repo, number }
    commentData.body = comment.getCommentBody signed,
        options.templates,
        _.extend options.templateData, { sender, payload }

    comment.send options.token, commentData, (err, data) ->
      if err
        console.log   JSON.parse err
        console.log   'Fatal Error: GitHub refused to comment'
        res.send 500, 'Fatal Error: GitHub refused to comment'
      else
        href = payload.pull_request._links.html.href
        console.log   "Success: Comment created at #{href}"
        res.send 200, "Success: Comment created at #{href}"

  skipCollaborators = (contractors) ->
    skip res, sender, options, contractors, { user, repo }, handleComment

  getContractors = ->
    options.getContractors skipCollaborators

  if payload.action is 'opened'

    if _.isFunction options.getContractors
      getContractors()
    else
      console.log   'Fatal Error: options#getContractors not provided'
      res.send 500, 'Fatal Error: options#getContractors not provided'

  else
    console.log   "Received \"#{payload.action}\", not an opened Pull Request"
    res.send 200, "Received \"#{payload.action}\", not an opened Pull Request"

exports.default = (req, res) ->
  res.send 'always at your service, clabot'
