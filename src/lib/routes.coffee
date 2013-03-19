'use strict'

_ = require 'lodash'

comment     = require './lib/comment'
pullRequest = require './lib/pull-request'

exports.notify = (req, res) ->
  options = req.clabotOptions
  payload = JSON.parse req.body.payload

  if payload.action is 'opened'
    sender = payload.sender.login
    contributors = options.getContributors()

    signed = _.contains contributors, sender

    commentData = pullRequest.getData payload

    commentData.body = comment.getCommentBody signed,
      options.templates,
      _.extend options.templateData, { sender, payload }

    comment.send options.token, commentData, (err, data) ->
      console.log err if err
      res.send (if err then [400,'fail'] else [200,'done'])...
  else
    res.send 200, 'not opened'

exports.default = (req, res) ->
    res.send 'always at your service, clabot!'
