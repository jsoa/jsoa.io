github = require 'github'
mongoose = require 'mongoose'
async = require 'async'

models = require '../models'
config = require '../config'


import_orgs = (orgs, callback)->
  funcs = for org in orgs
    do(org)->
      (cb)->
        options =
          org_id: org.org_id
          name: org.name
          description: org.description
          url: org.url
          payload: org

        import_org options, ->
          cb null, org.org_id

  async.parallel funcs, (err, res)->
    callback err, res

import_org = (options, callback)->
  Org = models.Org(mongoose)

  Org.findOne {org_id: options.org_id}, (err, obj)->
    if obj
      console.log "Found org (#{ options.org_id }) - (#{ options.name }), skipping"
      callback err, obj
      return
    org = new Org(
      org_id: options.org_id
      name: options.name
      description: options.description
      url: options.url
      payload: options.payload)

    org.save (err, obj)->
      console.log "Created org (#{ options.name }), (#{ options.org_id })"
      callback err, obj

get_github_orgs = (callback)->
  console.log "starting github org import"

  g = new github {'version': '3.0.0'}

  results = []
  g.orgs.getFromUser {user: config.github.account, per_page: 100}, (err, orgs)->
    if err
      callback err

    funcs = for org in orgs
      do(org)->
        (cb)->
          g.orgs.get {org: org.login}, (err, o)->
            cb err, o

    async.parallel funcs, (err, ogs)->
      callback null, ({
        org_id: org.id
        name: org.name or org.login
        description: org.description
        url: org.html_url
        payload: org} for org in ogs)


exports.run = ->
  if not config.github
    return

  get_github_orgs (err, orgs)->
    import_orgs orgs, (err, results)->
      console.log 'DONE'
