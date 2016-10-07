cron = require 'cron'
imports = require '../imports'
db = require '../db'



job1 = new cron.CronJob(
  '*/45 * * * *',
  ->
    imports.activity()
  , null, true)


job2 = new cron.CronJob(
  '*/45 * * * *',
  ->
    imports.repos()
    imports.orgs()
    imports.gists()
  , null, true)

console.log 'started jobs'
