twit = require 'twit'
github = require 'github'
mongoose = require 'mongoose'
async = require 'async'

config = require '../config'
models = require '../models'


import_payloads = (payloads, callback)->

  funcs = for payload in payloads
    do (payload)->
      (cb)->
        options =
          source: payload.source
          source_id: payload.source_id
          text: payload.text
          date: payload.date
          payload: payload.payload

        import_payload options, ->
          cb null, payload.source_id

  async.parallel funcs, (err, res)->
    callback err, res


import_payload = (options, cb)->

  Activity = mongoose.model 'Activity', models.activitySchema

  Activity.findOne {source: options.source, source_id: options.source_id}, (err, obj)->
    if obj
      console.log "Found Object (#{ options.source } - #{ options.source_id }), skipping"
      cb(err, obj)
      return

    act = new Activity(
      source: options.source
      source_id: options.source_id
      text: options.text
      date: options.date
      payload: options.payload
    )
    act.save (err, obj)->
      console.log "Created object (#{ options.source } - #{ options.source_id })"
      cb(err, obj)


get_twitter = (cb)->
  console.log 'starting twitter import'
  t = new twit(
    config.twitter_creds
  )

  t.get 'statuses/user_timeline', {count: 300}, (err, tweets)->

    results = ({
      source: 'twitter-timeline',
      source_id: tweet.id,
      text: tweet.text,
      date: tweet.created_at,
      payload: tweet} for tweet in tweets)
    cb err, results


get_github = (cb)->
  console.log 'starting github import'
  g = new github {'version': '3.0.0'}

  funcs = for x in [0..2]
    do(x)->
      (calb)->
        console.log x
        g.events.getFromUserPublic {user: 'jsoa', page: x}, (err, events)->
          if err
            calb err
            return

          calb null, ({
            source: 'github-events',
            source_id: event.id,
            text: event.type,
            date: event.created_at,
            payload: event} for event in events)

  async.parallel funcs, (err, lists)->
    res = []
    for list in lists
      res = res.concat list

    cb null, res


mongoose.connect config.mongo_connection
db = mongoose.connection

db.on 'error', console.error.bind(console, 'connection error')
db.once 'open', ->
  import_funcs = [get_github, get_twitter]

  funcs = for func in import_funcs
    do(func)->
      (cb)->
        func (err, res)->
          import_payloads res, (err, results)->
            cb err, results

  async.parallel funcs, (err, res)->
    console.log 'DONE'
    mongoose.disconnect()