

exports.twitter_creds =
  consumer_key: process.env.TWIT_CONSUMER_KEY or ''
  consumer_secret: process.env.TWIT_CONSUMER_SECRET or ''
  access_token: process.env.TWIT_ACCESS_TOKEN or ''
  access_token_secret: process.env.TWIT_ACCESS_TOKEN_SECRET or ''

exports.mongo_connection = process.env.MONGO_CONNECTION or 'mongodb://jsoa@localhost'
