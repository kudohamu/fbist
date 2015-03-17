fvistFoundationApp.controller("summaryController", ["$scope", "$resource", "recordFactory", "gundamsFactory", "friendsFactory", "recordTotalFactory", "recordSummaryFactory", "selectGundamFactory", "selectFriendFactroy", "messageFactory", function($scope, $resource, recordFactory, gundamsFactory, friendsFactory, recordTotalFactory, recordSummaryFactory, selectGundamFactory, selectFriendFactroy, messageFactory) {
  //初期化
  $scope.sort = { no: true, total: false, won: false, lost: false, rate: false };
  var costs_array = [
      { "name": "ALLコスト", "cost": 0 },
      { "name": "3000", "cost": 3000 },
      { "name": "2500", "cost": 2500 },
      { "name": "2000", "cost": 2000 },
      { "name": "1000", "cost": 1000 }
    ];
  $scope.record = {id:1, gundam: { id: 1, image_path: "", name: "" }, won: true, free: true, ranked: true, friend: { id: 1, image_path: "", name: "" }};
  $scope.asc = true;
  $scope.reverse = false;
  $scope.predicate = "no";
  $scope.options_costs = costs_array;
  $scope.filter_cost = $scope.options_costs[0].cost;

  function getTotal() {
    $scope.total = recordTotalFactory.get(function() {
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

    $scope.records = recordSummaryFactory.query(function() {
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

  $scope.gundams = gundamsFactory.query(function() {
    $scope.gundamList__searchText = "";
    $scope.gundamList__filterCost = $scope.options_costs[0].cost;
    $scope.record.gundam.image_path = $scope.gundams[0].image_path;
    $scope.record.gundam.name = $scope.gundams[0].name;
    $scope.record.gundam.id = $scope.gundams[0].id;
  }, 
  function() {
  
  });

  $scope.friend_list = friendsFactory.query(function() {
    $scope.friendList__searchText = "";
    $scope.record.friend.id = $scope.friend_list[0].id;
    $scope.record.friend.image_path = $scope.friend_list[0].image_path;
    $scope.record.friend.name = $scope.friend_list[0].name;
  },
  function() {

  });

  $scope.selectGundamClick = function() {
    selectGundamFactory.selectGundamClick();
  };

  $scope.selectGundam = function(index) {
    selectGundamFactory.selectGundam(index, $scope.record);
  };

  $scope.selectFriendClick = function() {
    selectFriendFactroy.selectFriendClick();
  };

  $scope.selectFriend = function(index) {
    selectFriendFactroy.selectFriend(index, $scope.record);
  };

  $scope.record__addButtonClick = function() {
    $scope.record__addButtonDisable = true;
    
    var record = new recordFactory;
    record.gundam_id = $scope.record.gundam.id;
    record.won = $scope.record.won;
    record.free = $scope.record.free;
    record.ranked = $scope.record.ranked;
    record.friend_id = $scope.record.friend.id;
    record.$save(function() {
      getTotal();
      getSummary();
      $scope.record__addButtonDisable = false;
      messageFactory.show("戦績を追加しました。");
    }, function() {
      messageFactory.show("戦績の追加に失敗しました。");
    });
    
  };
}]);


