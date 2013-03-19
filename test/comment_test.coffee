'use strict'

fs   = require 'fs'
path = require 'path'

comment = require '../src/lib/comment'

alreadySigned = fs.readFileSync path.resolve(__dirname, 'fixtures/alreadySigned.md'), 'UTF-8'
notYetSigned  = fs.readFileSync path.resolve(__dirname, 'fixtures/notYetSigned.md'), 'UTF-8'

templates =
  alreadySigned: fs.readFileSync path.resolve(__dirname, '../src/templates', 'alreadySigned.template.md'), 'UTF-8'
  notYetSigned : fs.readFileSync path.resolve(__dirname, '../src/templates', 'notYetSigned.template.md'), 'UTF-8'

exports.comment  =
  getCommentBody: (test) ->
    test.expect 2

    test.equal alreadySigned,
      comment.getCommentBody(yes, templates, {
          image: no
          sender: 'davidpfahler'
          maintainer: 'boennemann'
          link: 'http://google.com'
        }),
      '"already signed comment body" looks good'

    test.equal notYetSigned,
      comment.getCommentBody(no, templates, {
          image: no
          sender: 'davidpfahler'
          link: 'http://google.com'
        }),
      '"not yet signed comment body" looks good'

    test.done()
