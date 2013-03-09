config = require '../config'


exports.rpcs = require './rpcs'

exports.index = (req, res)->
  console.log 'config index', config

  res.render 'index', config

exports.about = (req, res)->
  res.render 'about', config
