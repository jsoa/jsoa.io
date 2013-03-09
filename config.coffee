exports.mongo =
  connection: process.env.MONGO_CONNECTION or 'mongodb://localhost'


exports.github =
  account: ''


exports.twitter =
  account: ''
  consumer_key: process.env.TWIT_CONSUMER_KEY or ''
  consumer_secret: process.env.TWIT_CONSUMER_SECRET or ''
  access_token: process.env.TWIT_ACCESS_TOKEN or ''
  access_token_secret: process.env.TWIT_ACCESS_TOKEN_SECRET or ''


exports.linkedin =
  path: ''


exports.blog =
  name: 'unknown blog'
  owner:
    displayName: 'Blog User'
    avatarUrl: ''
    jobTitle: 'Ditch Digger'
    email: "<a href='mailto:example@example.org'>example@example.org</a>"


install = ->
  try
    exports = module.exports = require './config-local'
    console.log 'local config used'
  catch err


install()
