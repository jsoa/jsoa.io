mongoose = require 'mongoose'
config = require './config'


mongoose.connect config.mongo.connection
exports.db = db = mongoose.connection


db.on 'error', console.error.bind(console, 'connection error')
db.once 'open', ->
  console.log 'db connected okay'
