'use strict'

_      = require 'lodash'
github = require 'github'

exports.getCommentBody = (signed, templates, templateData) ->
  if signed
    _.template templates.alreadySigned, templateData
  else
    _.template templates.notYetSigned, templateData

exports.send = (token, msg, callback) ->
  api = new github
    version: '3.0.0'

  api.authenticate
    type: 'oauth'
    token: token

  api.issues.createComment msg, callback
