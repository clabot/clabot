'use strict'

_      = require 'lodash'
github = require 'github'

errorHandler = (err, res) ->
  msg = 'Fatal Error: GitHub refused to list Collaborators/Contributors'
  console.log msg
  console.log JSON.parse err
  res.send 500, msg

exports = module.exports = (res, sender, options, contractors, msg, callback) ->
  api = new github
    version: '3.0.0'

  api.authenticate
    type: 'oauth'
    token: options.token

  collabs = (toBeSkipped, callback) ->
    api.repos.getCollaborators msg, (err, collaborators) ->
      if err then errorHandler err, res
      _.each collaborators, (collaborator) ->
        toBeSkipped.push collaborator.login
      callback toBeSkipped

  contribs = (toBeSkipped, callback) ->
    api.repos.getContributors msg, (err, contributors) ->
      if err then errorHandler err, res
      _.each contributors, (contributor) ->
        toBeSkipped.push contributor.login
      callback toBeSkipped

  skip = (toBeSkipped) ->
    if _.contains toBeSkipped, sender
      console.log   'Skipping Collaborator/Contributor'
      res.send 200, 'Skipping Collaborator/Contributor'
    else
      callback(contractors)

  if options.skipCollaborators and options.skipContributors
    collabs [], (toBeSkipped) ->
      contribs toBeSkipped, (toBeSkipped) ->
        skip toBeSkipped
  else if options.skipCollaborators and not options.skipContributors
    collabs [], (toBeSkipped) ->
      skip toBeSkipped
  else if options.skipContributors
    contribs [], (toBeSkipped) ->
      skip toBeSkipped
  else
    callback(contractors)



