github = require 'github'
mongoose = require 'mongoose'
async = require 'async'

models = require '../models'

import_repos = (repos, callback)->
  funcs = for repo in repos
    do(repo)->
      (cb)->
        options =
          repo_id: repo.repo_id
          name: repo.name
          description: repo.description
          url: repo.url
          updated: repo.updated
          owner: repo.owner
          payload: repo

        import_repo options, ->
          cb null, repo.repo_id

  async.parallel funcs, (err, res)->
    callback err, res

import_repo = (options, callback)->
  Repo = mongoose.model 'Repo', models.repoSchema

  Repo.findOne {repo_id: options.repo_id}, (err, obj)->
    if obj
      console.log "Found repo (#{ options.name }) - (#{ options.repo_id }), skipping"
      callback err, obj
      return

    repo = new Repo(
      repo_id: options.repo_id
      name: options.name
      description: options.description
      url: options.url
      updated: options.updated
      owner: options.owner
      payload: options.payload
    )

    repo.save (err, obj)->
      console.log "Created repo (#{ options.name }), (#{ options.repo_id })"
      callback err, obj

get_github_repos = (owner, callback)->
  console.log 'starting github repo import'

  g = new github {'version': '3.0.0'}

  func = g.repos.getFromUser
  if not owner
    func = g.repos.getWatchedFromUser

  funcs = for x in [1..2]
    do(x)->
      (cb)->
        func {user: 'jsoa',  page: x}, (err, repos)->
          if err
            cb err
            return

          cb null, ({
            repo_id: repo.id
            name: repo.name
            description: repo.description
            url: repo.html_url
            updated: repo.updated_at
            owner: owner
            payload: repo} for repo in repos)

  async.parallel funcs, (err, lists)->
    res = []
    for list in lists
      res = res.concat list
    callback null, res


exports.run = ->
  # Import watching repos and repos owned
  get_github_repos true, (err, repos)->
      import_repos repos, (err, results)->

        get_github_repos false, (err, repos)->
          import_repos repos, (err, results)->

            console.log 'DONE'
