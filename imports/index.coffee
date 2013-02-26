act = require './activity'
rep = require './repos'
org = require './orgs'
gis = require './gists'

exports.activity = act.run
exports.repos = rep.run
exports.orgs = org.run
exports.gists = gis.run