mongoose = require 'mongoose'

# The main schema for any activity payload
exports.activitySchema = mongoose.Schema
  source: 'string'
  source_id: 'string'
  text: 'string'
  date: 'date'
  payload: {}
exports.activitySchema.index({source: 1, source_id: 1}, {unique: true})
exports.Activity = (conn=mongoose)->
  conn.model 'Activity', exports.activitySchema


# The gist data schema
exports.gistSchema = mongoose.Schema
  id: 'number'
  date: 'date'
  url: 'string'
  title: 'string'
exports.gistSchema.index({id: 1}, {unique: true})
exports.Gist = (conn=mongoose)->
  conn.model 'Gist', exports.gistSchema


# The repository schema
exports.repoSchema = mongoose.Schema
  repo_id: 'number'
  name: 'string'
  description: 'string'
  url: 'string'
  updated: 'date'
  owner: 'boolean'
  payload: {}
exports.repoSchema.index({repo_id: 1}, {unique: true})
exports.Repo = (conn=mongoose)->
  conn.model 'Repo', exports.repoSchema


# Organization schema
exports.orgSchema = mongoose.Schema
  org_id: 'number'
  name: 'string'
  description: 'string'
  url: 'string'
  payload: {}
exports.orgSchema.index({org_id: 1}, {unique: true})
exports.Org = (conn=mongoose)->
  conn.model 'Org', exports.orgSchema
