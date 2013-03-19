'use strict'

exports.getSender = (payload) ->
  if payload.action is 'opened' and payload.pull_request?
    payload.sender.login
  else
    null

exports.getData = (payload) ->
  user: payload.repository.owner.login
  repo: payload.repository.name
  number: payload.number
