exports.mongo =
  connection: process.env.MONGO_CONNECTION or 'mongodb://localhost'


exports.github =
  account: process.env.GITHUB_ACCOUNT or ''
  token: process.env.GITHUB_TOKEN or ''


exports.twitter =
  account: ''
  oauth:
    consumer_key: process.env.TWIT_CONSUMER_KEY or ''
    consumer_secret: process.env.TWIT_CONSUMER_SECRET or ''
    access_token: process.env.TWIT_ACCESS_TOKEN or ''
    access_token_secret: process.env.TWIT_ACCESS_TOKEN_SECRET or ''


exports.linkedin =
  path: ''


exports.blog =
  name: 'unknown'
  owner:
    displayName: 'user'
    avatarUrl: ''
    jobTitle: ''
    email: ''


exports.google_plus =
 key: process.env.GOOGLE_PLUS_KEY or ''
 account: process.env.GOOGLE_PLUS_ACCOUNT or ''


exports.cron =
  standalone: false


exports.analytics =
  account: ''
  tracking_id: ''
  domain: ''


# end default config.
(->
  try
    exports = module.exports = require './config-local'
    console.log 'loaded config-local'
  catch err
    console.log 'config-local error', err
)()
