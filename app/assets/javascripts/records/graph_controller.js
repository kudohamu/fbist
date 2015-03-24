fvistFoundationApp.controller("recordsGraphController", ["$scope", "$document", "graphFactory", "gundamsFactory", "selectGundamFactory", "friendsFactory", "selectFriendFactroy", function($scope, $document, graphFactory, gundamsFactory, selectGundamFactory, friendsFactory, selectFriendFactroy) {
  $scope.record = { gundam: { id: 1, image_path: "", name: "" }, friend: { id: 1, image_path: "", name: "" }}

  //キャンバスの設定
  var canvas = $document.find("canvas")[0];
  canvas.width = 750;
  canvas.height = 500;
  var ctx = canvas.getContext("2d");
  ctx.font = "10px 'メイリオ'";

  //表示区間
  var sections_array = [
    { name: "10戦ごと",   section: "1:10"   },
    { name: "50戦ごと",   section: "1:50"   },
    { name: "100戦ごと",  section: "1:100"  },
    { name: "300戦ごと",  section: "1:300"  },
    { name: "500戦ごと",  section: "1:500"  },
    { name: "1000戦ごと", section: "1:1000" },
    { name: "1日ごと",    section: "2:1"    },
    { name: "1週間ごと",  section: "3:1"    },
    { name: "1ヶ月ごと",  section: "4:1"    },
    { name: "3ヶ月ごと",  section: "4:3"    },
    { name: "6ヶ月ごと",  section: "4:6"    },
  ];
  $scope.options_sections = sections_array;
  $scope.filter_section = $scope.options_sections[0].section;

  $scope.sectionChange = function() {
    getData();
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
    getData();
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
    getData();
  };

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

  $scope.initializeGraph = function() {
    var c_w = canvas.width;
    var c_h = canvas.height;
    var offset_x = c_w / ($scope.graphData.length * 2);
    var offset_y = c_h / (11 * 2);
    ctx.clearRect(0,0,c_w, c_h);

    changeCanvasStyle(1,"rgba(0,0,0,0.3)");
    for(var i = 0; i < 11; i++) {
      ctx.strokeText(i*10 + "%", offset_x/4, c_h - (c_h * i / 11) - offset_y*1.25);
      drawLine(offset_x/2, c_h - (c_h * i / 11) - offset_y, c_w - offset_x/2, c_h - (c_h * i / 11) - offset_y);
    }
    changeCanvasStyle(3,"rgb(202,37,37)");
  };

  $scope.drawGraph = function() {
    var c_w = canvas.width;
    var c_h = canvas.height;
    var offset_x = c_w / ($scope.graphData.length * 2);
    var offset_y = c_h / (11 * 2);

    //点
    $scope.graphData.forEach(function(value, index) {
      var x = c_w * index / $scope.graphData.length + offset_x;
      var pos = c_h * value.rate / 110;
      var y = c_h - pos - offset_y;
      drawCircle(x,y,2);
    });

    //線
    for(var i = 0; i < $scope.graphData.length - 1; i++) {
      var pre_x = c_w * i / $scope.graphData.length + offset_x;
      var pos = c_h * $scope.graphData[i].rate / 110;
      var pre_y = c_h - pos - offset_y;
      
      var next_x = c_w * (i + 1) / $scope.graphData.length + offset_x;
      var pos = c_h * $scope.graphData[i + 1].rate / 110;
      var next_y = c_h - pos - offset_y;

      drawLine(pre_x, pre_y, next_x, next_y);
    }
  };

  function getData() {
    $scope.graphData = graphFactory.query({ 
      section: $scope.filter_section, 
      team: $scope.filter_team, 
      match: $scope.filter_match,
      gundam_id: $scope.record.gundam.id,
      friend_id: $scope.record.friend.id
    }, 
    function() {
      $scope.initializeGraph();
      $scope.drawGraph();
    }, 
    function() {
    });
  }
  getData();

  //キャンバス周り
  function drawCircle(x, y, r) {
    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI*2, false);
    ctx.stroke();
    ctx.fill();
    ctx.closePath();
  };

  function drawLine(s_x, s_y, e_x, e_y) {
    ctx.beginPath();
    ctx.moveTo(s_x, s_y);
    ctx.lineTo(e_x, e_y);
    ctx.stroke();
    ctx.closePath();
  }

  function changeCanvasStyle(lineWidth, color) {
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = lineWidth;
  }

  //ガンダム一覧取得
  $scope.gundams = gundamsFactory.query({
    all: true
  }, function() {
    $scope.gundamList__searchText = "";
    $scope.gundamList__filterCost = $scope.options_costs[0].cost;
    $scope.record.gundam.image_path = $scope.gundams[0].image_path;
    $scope.record.gundam.name = $scope.gundams[0].name;
    $scope.record.gundam.id = $scope.gundams[0].id;
  }, 
  function() {
  
  });

  $scope.selectGundamClick = function() {
    selectGundamFactory.selectGundamClick();
  };

  $scope.selectGundam = function(index) {
    selectGundamFactory.selectGundam(index, $scope.record);
    getData();
  };

  //フレンドリスト取得
  $scope.friend_list = friendsFactory.query({
    other: true,
    all: true
  }, 
  function() {
    $scope.friendList__searchText = "";
    $scope.record.friend.id = $scope.friend_list[0].id;
    $scope.record.friend.image_path = $scope.friend_list[0].image_path;
    $scope.record.friend.name = $scope.friend_list[0].name;
  },
  function() {

  });

  $scope.selectFriendClick = function() {
    selectFriendFactroy.selectFriendClick();
  };

  $scope.selectFriend = function(index) {
    selectFriendFactroy.selectFriend(index, $scope.record);
    getData();
  };
}]);
