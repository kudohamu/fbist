fvistFoundationApp.controller("friendsIndexController", ["$scope", "$resource", "friendsFactory", "followerFactory", "messageFactory", function($scope, $resource, friendsFactory, followerFactory, messageFactory) {
  //フォロイー取得
  function getFriendList() {
    $scope.loadingRecords = true;
    $scope.friend_list = friendsFactory.query({
    }, function() {
      $scope.friendsIndex__searchText = "";
      $scope.loadingSuccess = true;
      $scope.loadingRecords = false;
    },
    function() {
      $scope.loadingFailed = true;
      $scope.loadingRecords = false;
    });
  }
  getFriendList();

  //フォロイー削除
  $scope.deleteFriendDivHide = function() {
    if (!$scope.friendDeleteDialogClick) {
      $scope.friendDeleteDialogShow = false;
    }else {
      $scope.friendDeleteDialogClick = false;
    }
  };

  $scope.deleteFriendClick = function(index, friend_id) {
    $scope.friendDeleteDialogShow = true;
    $scope.deleteFriend_id = friend_id;
    $scope.deleteFriend_index = index;
  };

  $scope.deleteFriend = function(friend_id) {
    $scope.friendDeleteDialogShow = false;
    friend = new friendsFactory;
    friend.id = friend_id;
    friend.$delete(function() {
      messageFactory.show("フォロー解除しました。");
      getFriendList();
    },
    function() {
      messageFactory.show("フォロー解除に失敗しました。");
      getFriendList();
    });
  };

  //フォロワー取得
  function getFollowerList() {
    $scope.loadingRecords = true;
    $scope.follower_list = followerFactory.query({
    }, function() {
      $scope.followerIndex__searchText = "";
      $scope.loadingSuccess = true;
      $scope.loadingRecords = false;
    },
    function() {
      $scope.loadingFailed = true;
      $scope.loadingRecords = false;
    });
  }
  getFollowerList();
}]);
