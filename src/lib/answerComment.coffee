'use strict'

_      = require 'lodash'
github = require 'github'

comment  = require './comment'

exports = module.exports = (req, res, options, contractors, payload) ->

  body   = payload.comment.body
  poster = payload.comment.user.login
  number = payload.issue.number
  repo   = payload.repository.name
  sender = payload.issue.user.login
  user   = payload.repository.owner.login

  regex = ///
  \[clabot
    (:
      ([a-zA-Z0-9]+) # Method
      \=?
      ([a-zA-Z0-9\_\-]+) # Argument
    ?)
  +\]
  ///

  [method, argument] = (body.match(regex) or []).slice 2

  api = new github
    version: '3.0.0'

  api.authenticate
    type: 'oauth'
    token: options.token

  api.user.get {}, (err, data) ->
    if not err and method is 'check' and data.login isnt poster
      signed = _.contains contractors, argument or sender

      commentData      = { user, repo, number }
      commentData.body = comment.getCommentBody signed,
          options.templates,
          _.extend options.templateData,
            sender : argument or sender
            payload: payload
            check  : yes

      comment.send options.token, commentData, (err, data) ->
        if err
          console.log err
          console.log   'Fatal Error: GitHub refused to comment'
          res.send 500, 'Fatal Error: GitHub refused to comment'
        else
          href = payload.comment.html_url
          console.log   "Success: Comment created at #{href}"
          res.send 200, "Success: Comment created at #{href}"
    else if not err and method is 'accept' and data.login isnt poster
      if poster is sender
        signed = _.contains contractors, poster

        if not signed
          if _.isFunction options.addContractor
            options.addContractor poster, (err, data) ->
              if err
                console.log err
                console.log   'Fatal Error: Unable to add signee'
                res.send 500, 'Fatal Error: Unable to add signee'
              else
                console.log   "Added signee and got response = #{data}"
                res.send 200, "Added signee and got response = #{data}"
                #TODO make a call to add an acceptance comment
          else
            console.log   'Fatal Error: options#addContractor not provided'
            res.send 500, 'Fatal Error: options#addContractor not provided'
        else
          console.log   'Contractor has already accepted the CLA'
          res.send 200, 'Contractor has already accepted the CLA'
      else
        console.log   'Contractor is not owner of the GitHub Pull Request'
        res.send 200, 'Contractor is not owner of the GitHub Pull Request'
    else
      if err then console.log err
      console.log   'Could not find proper clabot command in comment'
      res.send 200, 'Could not find proper clabot command in comment'
