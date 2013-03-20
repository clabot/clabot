'use strict'

_ = require 'lodash'

comment  = require './comment'
skip     = require './skip'

exports = module.exports = (req, res, options, contractors, payload) ->

  number = payload.number
  sender = payload.sender.login
  repo   = payload.repository.name
  user   = payload.repository.owner.login

  skip res, sender, options, contractors, { user, repo }, (contractors) ->
    signed = _.contains contractors, sender

    commentData      = { user, repo, number }
    commentData.body = comment.getCommentBody signed,
        options.templates,
        _.extend options.templateData, { sender, payload }

    comment.send options.token, commentData, (err, data) ->
      if err
        console.log err
        console.log   'Fatal Error: GitHub refused to comment'
        res.send 500, 'Fatal Error: GitHub refused to comment'
      else
        href = payload.pull_request._links.html.href
        console.log   "Success: Comment created at #{href}"
        res.send 200, "Success: Comment created at #{href}"
