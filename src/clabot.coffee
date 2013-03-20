'use strict'

_       = require 'lodash'
express = require 'express'

routes = require './lib/routes'

exports.createApp = (options) ->
  # Just pick the options we need
  options = _.pick options, [
    'getContributors'
    'token'
    'templates'
    'templateData'
    'secrets'
  ]

  # Create new Express app
  app = express()

  # Middleware to allow CORS on all requests
  allowCrossDomain = (req, res, next) ->
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,POST');
    res.header('Access-Control-Allow-Headers', 'Content-Type,X-Hub-Signature');
    next()

  # Middleware to provide clabot options
  provideClabotOptions = (req, res, next) ->
    req.clabotOptions = options
    next()

  # Apply middlewares
  app.use allowCrossDomain
  app.use provideClabotOptions
  app.use express.bodyParser()

  # GET
  app.get '/', routes.default
  # POST
  app.post '/notify', routes.notify

  # Finally return app
  app
