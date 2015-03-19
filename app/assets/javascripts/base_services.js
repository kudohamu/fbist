var appName = "FVistFoundation";
var fvistFoundationApp = angular.module(appName, ["ngResource", "ngAnimate"]);

fvistFoundationApp.config(
  ["$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content");
  }]
);

//resource周りのfactory
fvistFoundationApp.factory("recordFactory", ["$resource", function($resource) {
  return $resource("/api/account/records/:id", {id: "@id"}, {
    update: {
      method: "PUT"
    }
  });
}]);

fvistFoundationApp.factory("gundamsFactory", ["$resource", function($resource) {
  return $resource("/api/gundams");
}]);

fvistFoundationApp.factory("friendsFactory", ["$resource", function($resource) {
  return $resource("/api/account/friends");
}]);


fvistFoundationApp.factory("recordTotalFactory", ["$resource", function($resource) {
  return $resource("/api/account/records/total");
}]);


//filter周りの共通処理
fvistFoundationApp.filter("gundamListFilter", ["$rootScope", "$filter", function($rootScope, $filter) {
  return function(items, input) {
    var result = $filter("filter")(items, input);
    $rootScope.filtedGundams = result;
    return result;
  };
}]);

fvistFoundationApp.filter("friendListFilter", ["$rootScope", "$filter", function($rootScope, $filter) {
  return function(items, input) {
    var result = $filter("filter")(items, input);
    $rootScope.filtedFriends = result;
    return result;
  };
}]);

//共通機能のfactory
fvistFoundationApp.factory("selectGundamFactory", ["$rootScope", function($rootScope) {
  return {
    selectGundam: function(index, record) {
      if ($rootScope.filtedGundams) {
        record.gundam.image_path = $rootScope.filtedGundams[index].image_path;
        record.gundam.name = $rootScope.filtedGundams[index].name;
        record.gundam.id = $rootScope.filtedGundams[index].id;
      }else {
        record.gundam.image_path = $rootScope.gundams[index].image_path;
        record.gundam.name = $rootScope.gundams[index].name;
        record.gundam.id = $rootScope.gundams[index].id;
      }
    },

    selectGundamClick: function() {
      $rootScope.gundamListDivShow = !$rootScope.gundamListDivShow;
    }
  };
}]);

fvistFoundationApp.factory("selectFriendFactroy", ["$rootScope", function($rootScope) {
  return {
    selectFriend: function(index, record) {
      if ($rootScope.filtedFriends) {
        record.friend.image_path = $rootScope.filtedFriends[index].image_path;
        record.friend.name = $rootScope.filtedFriends[index].name;
        record.friend.id = $rootScope.filtedFriends[index].id;
      }else {
        record.friend.image_path = $rootScope.friend_list[index].image_path;
        record.friend.name = $rootScope.friend_list[index].name;
        record.friend.id = $rootScope.friend_list[index].id;
      }
    },

    selectFriendClick: function() {
      $rootScope.friendListDivShow = !$rootScope.friendListDivShow;
    }
  };
}]);

fvistFoundationApp.factory("messageFactory", ["$rootScope", "$timeout", function($rootScope, $timeout) {
  return {
    show: function(message) {
      $rootScope.message = message;
      $rootScope.messageCSS = "messageShow";
      $timeout(function() {
        $rootScope.messageCSS = "";
      }, 5000);
    }
  };
}]);
