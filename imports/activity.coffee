twit = require 'twit'
github = require 'github'
mongoose = require 'mongoose'
async = require 'async'
GooglePlus = require 'Google_Plus_API'

config = require '../config'
models = require '../models'


import_payloads = (payloads, callback)->
  console.log "importing payloads #{payloads.length}"
  funcs = for payload in payloads when payload
    do (payload)->
      (cb)->
        options =
          source: payload.source
          source_id: payload.source_id
          text: payload.text
          date: payload.date
          payload: payload.payload
        import_payload options, (err, id)->
          cb err, payload.source_id

  async.parallel funcs, (err, res)->
    console.log "payload import complete #{err}, #{res?}"
    callback err, res


import_payload = (options, cb)->
  Activity = mongoose.model 'Activity', models.activitySchema
  query =
    source: options.source
    source_id: options.source_id

  Activity.findOne query, (err, obj)->
    if obj
      console.log "Existing object (#{options.source} - #{options.source_id})"
      return cb err, obj

    act = new Activity(
      source: options.source
      source_id: options.source_id
      text: options.text
      date: options.date
      payload: options.payload
    )
    act.save (err, obj)->
      if err
        console.log "error saving object #{err}"
      else
        console.log "Created object (#{options.source} - #{options.source_id})"
      cb err, obj


get_twitter = (cb)->
  console.log 'starting twitter import'
  t = new twit(
    config.twitter.oauth
  )
  t.get 'statuses/user_timeline', {count: 300}, (err, tweets)->
    if not err
      console.log "fetched tweets #{tweets.length}"
      results = ({
        source: 'twitter-timeline',
        source_id: tweet.id,
        text: tweet.text,
        date: tweet.created_at,
        payload: tweet} for tweet in tweets)
    else
      console.log "error fetching tweets #{err}"
      results = null
    cb err, results


get_github = (cb)->
  console.log 'starting github import'
  g = new github {'version': '3.0.0'}

  g.authenticate
    type: 'oauth'
    token: config.github_creds.token

  funcs = for x in [1..5]
    do(x)->
      (calb)->
        q = {user: config.github.account, page: x}
        g.events.getFromUserPublic q, (err, events)->
          if err
            console.log "error fetching github events #{err}"
            results = null
          else
            console.log "fetched github events #{events.length}"
            results = ({
            source: 'github-events',
            source_id: event.id,
            text: event.type,
            date: event.created_at,
            payload: event} for event in events)
          calb err, results

  async.parallel funcs, (err, lists)->
    res = []
    if not err
      for list in lists
        res = res.concat list
    cb err, res


get_google_plus = (cb)->
  console.log 'starting google+ import'
  gplus = new GooglePlus config.google_plus.key
  gplus.getActivites config.google_plus.account, 'public', (err, res)->
    if not err
      console.log "fetched google+ activities #{res.items.length}"
      results = ({
        source: "google-plus-#{r.kind.split('#')[1]}"
        source_id: r.id
        text: r.title
        date: r.published
        payload: r
      } for r in res.items)
    else
      results = []
      console.log "error fetching google+ activities #{err}"
    cb err, results


exports.run = ->
  import_funcs = []
  if config.google_plus
    import_funcs.push get_google_plus
  if config.github
    import_funcs.push get_github
  if config.twitter
    import_funcs.push get_twitter

  funcs = for func in import_funcs
    do(func)->
      (cb)->
        func (err, res)->
          import_payloads res, (err, results)->
            cb err, results

  async.parallel funcs, (err, res)->
    if err
      console.log "activity import complete with error #{err}"
    else
      console.log 'activity imports complete'
