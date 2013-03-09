db = require '../db'
imports = require '../imports'

console.log 'manual jobs'

imports.activity()
imports.repos()
imports.orgs()
imports.gists()


setTimeout (->), 20000