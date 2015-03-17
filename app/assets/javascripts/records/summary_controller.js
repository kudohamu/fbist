fvistFoundationApp.controller("summaryController", ["$scope", "$resource", "recordFactory", "gundamsFactory", "friendsFactory", "recordTotalFactory", "recordSummaryFactory", "selectGundamFactory", "selectFriendFactroy", "messageFactory", function($scope, $resource, recordFactory, gundamsFactory, friendsFactory, recordTotalFactory, recordSummaryFactory, selectGundamFactory, selectFriendFactroy, messageFactory) {
  //初期化
  $scope.record = {id:1, gundam: { id: 1, image_path: "", name: "" }, won: true, free: false, ranked: false, friend: { id: 1, image_path: "", name: "" }};
  $scope.loadingUser = true;

  //並び替え関連
  $scope.sort = { no: true, total: false, won: false, lost: false, rate: false };
  $scope.asc = true;
  $scope.reverse = false;
  $scope.predicate = "no";

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

  //絞り込み関連
  //コスト
  var costs_array = [
      { name: "ALLコスト", cost: 0    },
      { name: "3000",      cost: 3000 },
      { name: "2500",      cost: 2500 },
      { name: "2000",      cost: 2000 },
      { name: "1000",      cost: 1000 }
  ];
  $scope.options_costs = costs_array;
  $scope.filter_cost = $scope.options_costs[0].cost;

  //表示期間
  var sections_array = [
    { name: "すべて",     section: "0:0"    },
    { name: "最新100件",  section: "1:100"  },
    { name: "最新300件",  section: "1:300"  },
    { name: "最新500件",  section: "1:500"  },
    { name: "最新1000件", section: "1:1000" },
    { name: "最新1週間",  section: "2:1"    },
    { name: "最新1ヶ月",  section: "3:1"    },
    { name: "最新3ヶ月",  section: "3:3"    },
    { name: "最新6ヶ月",  section: "3:6"    },
    { name: "最新1年",    section: "4:1"    }
  ];
  $scope.options_sections = sections_array;
  $scope.filter_section = $scope.options_sections[0].section;

  $scope.sectionChange = function() {
    getTotal();
    getSummary();
  };

  //チーム
  var teams_array = [
    { name: "すべて",     team: 0 },  
    { name: "シャッフル", team: 1 },  
    { name: "フリー",     team: 2 },  
  ];
  $scope.options_teams = teams_array;
  $scope.filter_team = $scope.options_teams[0].team;

  $scope.teamChange = function() {
    getTotal();
    getSummary();
  };

  //マッチ
  var matches_array = [
    { name: "すべて",       match: 0 },  
    { name: "プレイマッチ", match: 1 },  
    { name: "ランクマッチ", match: 2 },  
  ];
  $scope.options_matches = matches_array;
  $scope.filter_match = $scope.options_matches[0].match;

  $scope.matchChange = function() {
    getTotal();
    getSummary();
  };

  
  //API叩く系
  //合計取得
  function getTotal() {
    $scope.total = recordTotalFactory.get({ section: $scope.filter_section, team: $scope.filter_team, match: $scope.filter_match }, function() {
      $scope.loadingUser = false;
    }, 
    function() {
      $scope.total = { record: "-- ", won: "-- ", lost: "-- ", rate: "-- " };
      $scope.loadingUser = false;
    });
  }
  getTotal();

  //機体別戦績取得
  function getSummary() {
    $scope.loadingRecords = true;
    $scope.loadingSuccess = false;
    $scope.loadingFailed  = false;

    $scope.records = recordSummaryFactory.query({ section: $scope.filter_section, team: $scope.filter_team, match: $scope.filter_match }, function() {
      $scope.loadingRecords = false;
      $scope.loadingSuccess = true;
    }, 
    function () {
      $scope.loadingRecords = false;
      $scope.loadingFailed = true;
    });
  }
  getSummary();

  //ガンダム一覧取得
  $scope.gundams = gundamsFactory.query(function() {
    $scope.gundamList__searchText = "";
    $scope.gundamList__filterCost = $scope.options_costs[0].cost;
    $scope.record.gundam.image_path = $scope.gundams[0].image_path;
    $scope.record.gundam.name = $scope.gundams[0].name;
    $scope.record.gundam.id = $scope.gundams[0].id;
  }, 
  function() {
  
  });

  //フレンドリスト取得
  $scope.friend_list = friendsFactory.query(function() {
    $scope.friendList__searchText = "";
    $scope.record.friend.id = $scope.friend_list[0].id;
    $scope.record.friend.image_path = $scope.friend_list[0].image_path;
    $scope.record.friend.name = $scope.friend_list[0].name;
  },
  function() {

  });

  //レコード追加周り
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


