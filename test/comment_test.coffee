'use strict'

fs   = require 'fs'
path = require 'path'

comment = require '../src/lib/comment'

alreadySigned = fs.readFileSync path.resolve(__dirname, 'expected/alreadySigned.md'), 'UTF-8'
notYetSigned  = fs.readFileSync path.resolve(__dirname, 'expected/notYetSigned.md'), 'UTF-8'

exports.comment  =
  getCommentBody: (test) ->
    test.expect 2

    test.equal alreadySigned,
      comment.getCommentBody(yes, {
          image: no
          sender: 'davidpfahler'
          maintainer: 'boennemann'
          link: 'http://google.com'
        }),
      '"already signed comment body" looks good'

    test.equal notYetSigned,
      comment.getCommentBody(no, {
          image: no
          sender: 'davidpfahler'
          link: 'http://google.com'
        }),
      '"not yet signed comment body" looks good'

    test.done()
