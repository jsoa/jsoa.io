// Generated by CoffeeScript 1.3.1
(function() {
  var app, linkToUrl, twitterify, urlRegExp;

  app = angular.module('jsoa', ['ngSanitize', 'angular.markdown']);

  urlRegExp = /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g;

  linkToUrl = function(url) {
    return url.link(url);
  };

  twitterify = (function() {
    var atUserRegExp, hashTagRegExp, linkToTag, linkToUser, twitterUrl;
    linkToUser = function(match, atUser, user) {
      return atUser.link(twitterUrl + "/#!/" + user);
    };
    linkToTag = function(match, hashTag, tag) {
      return hashTag.link(twitterUrl + "/search/?q=%23" + tag);
    };
    twitterUrl = "https://twitter.com";
    atUserRegExp = /(@([A-Za-z0-9-_]+))/g;
    hashTagRegExp = /(#([A-Za-z0-9_]+))/g;
    return function(str) {
      return str.replace(urlRegExp, linkToUrl).replace(atUserRegExp, linkToUser).replace(hashTagRegExp, linkToTag);
    };
  })();

  app.filter('truncate', function() {
    return function(text, length, end) {
      if (isNaN(length)) {
        length = 10;
      }
      if (end === void 0) {
        end = "...";
      }
      if (text.length <= length || text.length - end.length <= length) {
        return text;
      } else {
        return String(text).substring(0, length - end.length) + end;
      }
    };
  });

  app.filter('tweetify', function() {
    return function(text) {
      return twitterify(text);
    };
  });

  app.filter('githubify', function() {
    return function(text) {
      return text.replace(urlRegExp, linkToUrl).replace(/\n/g, '<br/>');
    };
  });

  app.filter('gitmessage', function() {
    return function(text, repo, sha) {
      var items, message, url;
      items = text.split('\n');
      message = items[0];
      url = "http://github.com/" + repo + "/commit/" + sha;
      return "<a href='" + url + "'>" + message + "</a>";
    };
  });

  this.HomeCtrl = function($scope, $http) {
    $http.get('/rpc/activity').success(function(res, status) {
      return $scope.items = res;
    });
    $http.get('/rpc/gists').success(function(res, status) {
      return $scope.gists = res;
    });
    $http.get('/rpc/repos/owned').success(function(res, status) {
      return $scope.repos_owned = res;
    });
    $http.get('/rpc/repos/watched').success(function(res, status) {
      return $scope.repos_watched = res;
    });
    return $http.get('/rpc/orgs').success(function(res, status) {
      return $scope.orgs = res;
    });
  };

}).call(this);
