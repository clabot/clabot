'use strict'

_      = require 'lodash'

comment  = require './comment'

exports = module.exports = (req, res, options, contractors, payload) ->

  body   = payload.comment.body
  number = payload.issue.number
  repo   = payload.repository.name
  sender = payload.issue.user.login
  user   = payload.repository.owner.login

  regex = ///
  \[clabot
    (:
      ([a-zA-Z0-9]+)
      \=?
      ([a-zA-Z0-9\_\-]+)
    ?)
  +\]
  ///

  console.log body
  console.log body.match(regex)

  [method, argument] = (body.match(regex) or []).slice 2

  if method is 'check'
    signed = _.contains contractors, argument or sender

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
        href = payload.comment.html_url
        console.log   "Success: Comment created at #{href}"
        res.send 200, "Success: Comment created at #{href}"
  else
    console.log   'Could not find clabot command in comment'
    res.send 200, 'Could not find clabot command in comment'

