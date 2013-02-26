github = require 'github'
mongoose = require 'mongoose'
async = require 'async'

models = require '../models'

import_gists = (gists, callback)->
  funcs = for gist in gists
    do (gist)->
      (cb)->
        import_gist gist.id, gist.gist, ->
          cb null, gist.id
  async.parallel funcs, (err, res)->
    callback err, res

import_gist = (id, gist, cb)->
  Gist = mongoose.model 'Gist', models.gistSchema

  Gist.findOne {id: id}, (err, obj)->
    if obj
      console.log "Found Object #{ id }, skipping"
      cb(err, obj)
      return

    gist = new Gist(
      id: id
      date: gist.created_at
      url: gist.html_url
      title: gist.description)

    gist.save (err, obj)->
      console.log "Created object #{ id }"
      cb(err, obj)

get_gists = (cb)->
  g = new github {'version': '3.0.0'}

  g.gists.getFromUser {user: 'jsoa'}, (err, gists)->
    results = ({
      id: gist.id,
      gist: gist} for gist in gists)
    cb err, results


exports.run = ->
  get_gists (err, res)->
    import_gists res, (err, results)->
      console.log 'DONE'
