'use strict'

exports.getData = (payload) ->
  user: payload.repository.owner.login
  repo: payload.repository.name
  number: payload.number
