

exports.rpcs = require './rpcs'

exports.index = (req, res)->
  res.render 'index'

exports.about = (req, res)->
  res.render 'about'
