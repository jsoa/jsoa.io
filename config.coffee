exports.mongo =
  connection: process.env.MONGO_CONNECTION or 'mongodb://localhost'


exports.github =
  account: process.env.GITHUB_ACCOUNT or ''
  key: process.env.GITHUB_KEY or ''
  token: process.env.GITHUB_TOKEN or ''


exports.twitter =
  account: process.env.TWIT_ACCOUNT or ''
  oauth:
    consumer_key: process.env.TWIT_CONSUMER_KEY or ''
    consumer_secret: process.env.TWIT_CONSUMER_SECRET or ''
    access_token: process.env.TWIT_ACCESS_TOKEN or ''
    access_token_secret: process.env.TWIT_ACCESS_TOKEN_SECRET or ''


exports.linkedin =
  path: process.env.LINKED_IN_PATH or ''


exports.blog =
  name: process.env.BLOG_NAME or ''
  owner:
    displayName: process.env.OWNER_DISPLAY_NAME or ''
    avatarUrl: process.env.OWNER_AVATAR_URL or ''
    jobTitle: process.env.OWNER_JOB_TITLE or ''
    email: process.env.OWNER_EMAIL or ''


exports.google_plus =
 key: process.env.GOOGLE_PLUS_KEY or ''
 account: process.env.GOOGLE_PLUS_ACCOUNT or ''


exports.cron =
  standalone: false


exports.analytics =
  account: process.env.ANALYTICS_ACCOUNT or ''
  tracking_id: process.env.ANALYTICS_TRACKING_ID or ''
  domain: process.env.ANALYTICS_DOMAIN or ''


# end default config.
(->
  try
    exports = module.exports = require './config-local'
    console.log 'loaded config-local'
  catch err
    console.log 'config-local error', err
)()
