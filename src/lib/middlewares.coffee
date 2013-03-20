'use strict'

qs = require 'qs'

_ = require 'lodash'

# Utils
mime = (req) ->
  str = req.headers['content-type'] or ''
  str.split(';')[0]

# Middlewares
exports.allowCrossDomain = (req, res, next) ->
  res.header 'Access-Control-Allow-Origin',  '*'
  res.header 'Access-Control-Allow-Methods', 'GET,POST'
  res.header 'Access-Control-Allow-Headers', 'Content-Type,X-Hub-Signature'
  next()

exports.provideClabotOptions = (options) ->
  middleware = (req, res, next) ->
    req.clabotOptions = _.clone options
    next()

exports.parseBodyKeepRaw = (req, res, next) ->
  if req.headers['x-hub-signature']
    buf = ''
    req.setEncoding 'utf8'
    req._body = true

    req.on 'data', (chunk) ->
      buf += chunk

    req.on 'end', ->
      req.rawBody = buf
      try
        req.body = (if buf.length then qs.parse(req.rawBody) else {})
        next()
      catch err
        next err
  else
    next()
