models = require '../models'


exports.activity = (req, res)->
  models.Activity().find().sort('field -date').limit(25).exec (err, objs)->
    res.json(objs)

exports.gists = (req, res)->
  models.Gist().find().sort('field -date').exec (err, objs)->
    res.json(objs)

exports.repos = (owner)->
  (req, res)->
    models.Repo().find({owner: owner}).sort('field -updated').exec (err, objs)->
      res.json(objs)

exports.orgs = (req, res)->
  models.Org().find().sort('field name').exec (err, objs)->
    res.json(objs)