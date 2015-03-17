fvistFoundationApp.controller("recordsIndexController", ["$scope", "$resource", "$location", "$anchorScroll", "recordFactory", "gundamsFactory", "friendsFactory", "selectGundamFactory", "selectFriendFactroy", "messageFactory", function($scope, $resource, $location, $anchorScroll, recordFactory, gundamsFactory, friendsFactory, selectGundamFactory, selectFriendFactroy, messageFactory) {
  $scope.records = [];
  $scope.page = 0;
  $scope.recordsMax = document.getElementById("records__max").value;
  $scope.recordLimited = false;
  var costs_array = [
      { "name": "ALLコスト", "cost": 0 },
      { "name": "3000", "cost": 3000 },
      { "name": "2500", "cost": 2500 },
      { "name": "2000", "cost": 2000 },
      { "name": "1000", "cost": 1000 }
    ];
  $scope.options_costs = costs_array;
  $scope.filter_cost = $scope.options_costs[0].cost;
  $scope.record = {id:1, gundam: { id: 1, image_path: "", name: "" }, won: true, free: true, ranked: true, friend: { id: 1, image_path: "", name: "" }};
  //編集前の情報を保持しておくためのレコード
  var edit_record = {id:1, gundam: { id: 1, image_path: "", name: "" }, won: true, free: true, ranked: true, friend: { id: 1, image_path: "", name: "" }};

  $scope.getRecords = function() {
    $scope.recordsLoading = true;
    res_records = recordFactory.query({offset: $scope.records.length}, function() {
      res_records.map(function(record) { $scope.records.push(record) });
      $scope.recordsLoading = false;

      if ($scope.recordsMax <= $scope.records.length) {
        $scope.recordLimited = true;
      }
    });
  };
  $scope.getRecords();

  $scope.moreLoad = function() {
    $scope.getRecords();
  };

  $scope.deleteRecord = function(id, index) {
    var record = new recordFactory;
    record.id = id;
    result = record.$delete(function() {
      $scope.records.splice(index, 1);
      $scope.recordsMax--;
      $scope.deleteRecordDivShow = !$scope.deleteRecordDivShow;
      messageFactory.show("削除しました。");
    }, function() {
      messageFactory.show("削除に失敗しました。");
    });
  };

  $scope.deleteRecordClick = function(id, index) {
    $scope.delete_record = $scope.records[index];
    $scope.delete_index = index;
    $scope.deleteRecordDivShow = !$scope.deleteRecordDivShow;
  };


  //更新周り
  $scope.updateRecordClick = function(id, index) {
    $location.hash(-3);
    $anchorScroll();

    $scope.record = $scope.records[index];
    recordCopy($scope.record, edit_record);
    $scope.update_index = index;
    $scope.updateRecordDivShow = true;
    $scope.updateRecordDivClick = false;
  };

  $scope.updateRecordHide = function() {
    if (!$scope.updateRecordDivClick) {
      recordCopy(edit_record, $scope.record);
      $scope.updateRecordDivShow = false;

      $location.hash($scope.update_index - 2);
      $anchorScroll();
    }
    $scope.updateRecordDivClick = false;
  };

  $scope.updateRecord = function(id, index) {
    var record = new recordFactory;
    record.id = id;
    record.gundam_id = $scope.record.gundam.id;
    record.won = $scope.record.won;
    record.free = $scope.record.free;
    record.ranked = $scope.record.ranked;
    record.friend_id = $scope.record.friend.id;

    result = record.$update(function() {
      messageFactory.show("更新しました。");
      $scope.updateRecordDivShow = false;
    }, function() {
      messageFactory.show("更新に失敗しました。");
      recordCopy(edit_record, $scope.record);
      $scope.updateRecordDivShow = false;
    });
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

  //レコードのディープコピー用
  function recordCopy(src, dst) {
    dst.id = src.id;
    dst.gundam.id = src.gundam.id;
    dst.gundam.name = src.gundam.name;
    dst.gundam.image_path = src.gundam.image_path;
    dst.won = src.won;
    dst.free = src.free;
    dst.ranked = src.ranked;
    dst.friend.id = src.friend.id;
    dst.friend.name = src.friend.name;
    dst.friend.image_path = src.friend.image_path;
  }

}]);
