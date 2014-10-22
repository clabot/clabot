'use strict'

_       = require 'lodash'
express = require 'express'

middlewares = require './lib/middlewares'
routes      = require './lib/routes'

exports.createApp = (options) ->

  # Default options
  _.defaults options,
    skipContributors: yes
    skipCollaborators: no

  # Create new Express app
  app = if options.app then options.app else express()

  # Just pick the options we need
  options = _.pick options, [
    'getContractors'
    'addContractor'
    'token'
    'templates'
    'templateData'
    'secrets'
    'skipCollaborators'
    'skipContributors'
  ]

  # Apply middlewares
  app.use middlewares.allowCrossDomain
  app.use middlewares.provideClabotOptions options
  app.use middlewares.parseBodyKeepRaw
  app.use express.bodyParser()

  # GET
  app.get '/', routes.default
  # POST
  app.post '/notify', routes.notify

  # Finally return app
  app
