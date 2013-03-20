'use strict'

exports.allowCrossDomain = (req, res, next) ->
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,POST');
  res.header('Access-Control-Allow-Headers', 'Content-Type,X-Hub-Signature');
  next()

exports.provideClabotOptions = (options) ->
  middleware = (req, res, next) ->
    req.clabotOptions = options
    next()
