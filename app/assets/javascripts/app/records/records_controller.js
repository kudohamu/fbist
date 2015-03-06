var appName = "FVistFoundation";
var fvistFoundationApp = angular.module(appName, ["ngResource"]);

fvistFoundationApp.config(
  ["$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content");
  }]
);

fvistFoundationApp.controller("summaryController", function($scope, $resource, recordFactory) {
  //初期化
  $scope.sort = { no: true, total: false, won: false, lost: false, rate: false };
  var costs_array = [
      { "name": "ALLコスト", "cost": 0 },
      { "name": "3000", "cost": 3000 },
      { "name": "2500", "cost": 2500 },
      { "name": "2000", "cost": 2000 },
      { "name": "1000", "cost": 1000 }
    ];
  $scope.record__add = { gundam: { id: 1, image_path: "", name: "" }, result: { won: true }, team: { free: true }, mode: { ranked: true }, friend: { id: 1, image_path: "", name: "" }};
  $scope.asc = true;
  $scope.reverse = false;
  $scope.predicate = "no";
  $scope.options_costs = costs_array;
  $scope.filter_cost = $scope.options_costs[0].cost;

  function getTotal() {
    var res = $resource("/api/account/records/total");
    $scope.total = res.get(function() {
      $scope.userLoading = true;
    }, 
    function() {
      $scope.total = { record: "-- ", won: "-- ", lost: "-- ", rate: "-- " };
      $scope.userLoading = true;
    });
  }
  getTotal();

  function getSummary() {
    $scope.recordsLoading = false;
    $scope.loadingSuccess = false;
    $scope.loadingFailed  = false;

    var res = $resource("/api/account/records/summary");
    $scope.records = res.query(function() {
      $scope.recordsLoading = true;
      $scope.loadingSuccess = true;
    }, 
    function () {
      $scope.recordsLoading = true;
      $scope.loadingFailed = true;
    });
  }
  getSummary();

  $scope.thClick = function(pred) {
    if ($scope.predicate == pred) {
      $scope.reverse = !$scope.reverse;
      $scope.asc = !$scope.asc;
    }else {
      $scope.predicate = pred;
      if (pred == "no") {
        $scope.reverse = false;
        $scope.asc = true;
      }else {
        $scope.reverse = true;
        $scope.asc = false;
      }

      $scope.sort["no"] = false;
      $scope.sort["total"] = false;
      $scope.sort["won"] = false;
      $scope.sort["lost"] = false;
      $scope.sort["rate"] = false;

      $scope.sort[pred] = true;
    }
  };

  $scope.arrowShow = function(pred, sc) {
    if (sc == "asc") {
      return ($scope.sort[pred] && $scope.asc);
    }else {
      return ($scope.sort[pred] && !($scope.asc));
    }
  };

  var gundams_res = $resource("/api/gundams");
  $scope.gundams = gundams_res.query(function() {
    $scope.gundamList__filterCost = $scope.options_costs[0].cost;
    $scope.record__add.gundam.image_path = $scope.gundams[0].image_path;
    $scope.record__add.gundam.name = $scope.gundams[0].name;
    $scope.record__add.gundam.id = $scope.gundams[0].id;
  }, 
  function() {
  
  });

  var friends_res = $resource("/api/account/friends?other=true");
  $scope.friend_list = friends_res.query(function() {
    $scope.record__add.friend.id = $scope.friend_list[0].id;
    $scope.record__add.friend.image_path = $scope.friend_list[0].image_path;
    $scope.record__add.friend.name = $scope.friend_list[0].name;
  },
  function() {
    console.log("failed");
  });

  $scope.selectGundam = function(index) {
    if ($scope.filtedGundams) {
      $scope.record__add.gundam.image_path = $scope.filtedGundams[index].image_path;
      $scope.record__add.gundam.name = $scope.filtedGundams[index].name;
      $scope.record__add.gundam.id = $scope.filtedGundams[index].id;
    }else {
      $scope.record__add.gundam.image_path = $scope.gundams[index].image_path;
      $scope.record__add.gundam.name = $scope.gundams[index].name;
      $scope.record__add.gundam.id = $scope.gundams[index].id;
    }
  };

  $scope.selectGundamClick = function() {
    $scope.gundamListDivShow = !$scope.gundamListDivShow;
  };

  $scope.selectFriend = function(index) {
    if ($scope.filtedFriends) {
      $scope.record__add.friend.image_path = $scope.filtedFriends[index].image_path;
      $scope.record__add.friend.name = $scope.filtedFriends[index].name;
      $scope.record__add.friend.id = $scope.filtedFriends[index].id;
    }else {
      $scope.record__add.friend.image_path = $scope.friend_list[index].image_path;
      $scope.record__add.friend.name = $scope.friend_list[index].name;
      $scope.record__add.friend.id = $scope.friend_list[index].id;
    }
  };

  $scope.selectFriendClick = function() {
    $scope.friendListDivShow = !$scope.friendListDivShow;
  };

  $scope.record__addButtonClick = function() {
    $scope.record__addButtonDisable = true;
    
    var record = new recordFactory;
    record.gundam_id = $scope.record__add.gundam.id;
    record.won = $scope.record__add.result.won;
    record.free = $scope.record__add.team.free;
    record.ranked = $scope.record__add.mode.ranked;
    record.friend_id = $scope.record__add.friend.id;
    record.$save(function() {
      getTotal();
      getSummary();
      $scope.record__addButtonDisable = false;
    });
    
  };
});

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
