fs   = require 'fs'
path = require 'path'

_       = require 'lodash'
express = require 'express'

comment     = require './lib/comment'
pullRequest = require './lib/pull-request'

exports.getApp = (options) ->
  _.defaults options,
    getContributors: (->[])
    token: null
    templates:
      alreadySigned: fs.readFileSync path.resolve(__dirname, 'templates', 'alreadySigned.template.md'), 'UTF-8'
      notYetSigned: fs.readFileSync path.resolve(__dirname, 'templates', 'notYetSigned.template.md'), 'UTF-8'
    templateData:
      image: no
      link: null
      maintainer: null
    #secrets:
    #  "#{owner}":
    #    "#{repo}": hub.secret

  options = _.pick options, [
    'getContributors'
    'token'
    'templates'
    'templateData'
    'secrets'
  ]

  app = express()

  allowCrossDomain = (req, res, next) ->
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,POST');
    res.header('Access-Control-Allow-Headers', 'Content-Type,X-Hub-Signature');
    next()


  app.use allowCrossDomain
  app.use express.bodyParser()

  app.get '/', (req, res) ->
    res.send 'always at your service, clabot!'

  app.post '/notify', (req, res) ->
    try
      payload = JSON.parse req.body.payload

      sender = pullRequest.getSender payload
      contributors = options.getContributors()

      signed = _.contains contributors, sender

      commentData = pullRequest.getData payload

      commentData.body = comment.getCommentBody signed,
        options.templates,
        _.extend options.templateData, { sender, payload }

      comment.send options.token, commentData, (err, data) ->
        console.log err if err
        res.send (if err then [400,'fail'] else [200,'done'])...
    catch e
      res.send 400, 'fail'

  app
