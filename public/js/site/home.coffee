
app = angular.module 'jsoa', ['ngSanitize', 'angular.markdown']

# URL link function
urlRegExp = /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g
linkToUrl = (url) ->
  url.link url

# REF: https://gist.github.com/furf/2415595
# Slightly changed
#     - tag regex so - are not matched
#     - tag link to use ?q=%23
twitterify = (->
  linkToUser = (match, atUser, user) ->
    atUser.link twitterUrl + "/#!/" + user
  linkToTag = (match, hashTag, tag) ->
    hashTag.link twitterUrl + "/search/?q=%23" + tag
  twitterUrl = "https://twitter.com"

  atUserRegExp = /(@([A-Za-z0-9-_]+))/g
  hashTagRegExp = /(#([A-Za-z0-9_]+))/g

  (str) ->
    str.replace(urlRegExp, linkToUrl)
      .replace(atUserRegExp, linkToUser)
      .replace(hashTagRegExp, linkToTag)
)()

# REF: https://gist.github.com/danielcsgomes/2478654
app.filter 'truncate', ->
  (text, length, end)->
    if isNaN(length)
      length = 10

    if end == undefined
      end = "..."

    if (text.length <= length || text.length - end.length <= length)
      return text;
    else
      return String(text).substring(0, length-end.length) + end

app.filter 'tweetify', ->
  (text)->
    twitterify(text)

app.filter 'githubify', ->
  (text)->
    text.replace(urlRegExp, linkToUrl).replace(/\n/g,'<br/>')


# When git messages are displayed, we only want the main message
# newlines are not considered part of the commit message
app.filter 'gitmessage', ->
  (text, repo, sha)->
    items = text.split('\n')
    message = items[0]
    url = "http://github.com/#{repo}/commit/#{sha}"
    return "<a href='#{ url }'>#{ message }</a>"


@HomeCtrl = ($scope, $http)->

  $http.get('/rpc/activity').success (res, status)->
    $scope.items = res

  $http.get('/rpc/gists').success (res, status)->
    $scope.gists = res

  $http.get('/rpc/repos/owned').success (res, status)->
    $scope.repos_owned = res

  $http.get('/rpc/repos/watched').success (res, status)->
    $scope.repos_watched = res

  $http.get('/rpc/orgs').success (res, status)->
    $scope.orgs = res