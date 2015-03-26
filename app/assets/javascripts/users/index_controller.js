fvistFoundationApp.controller("usersIndexController", ["$scope", "$resource", "friendsFactory", "usersFactory", "messageFactory", function($scope, $resource, friendsFactory, usersFactory, messageFactory) {

  function getUsers() {
    $scope.loadingRecords = true;
    $scope.user_list = usersFactory.query(function() {
      $scope.usersIndex__searchText = "";
      $scope.loadingSuccess = true;
      $scope.loadingRecords = false;
    },
    function() {
      $scope.loadingFailed = true;
      $scope.loadingRecords = false;
    });
  }
  getUsers();

  $scope.addFriendDivHide = function() {
    if (!$scope.friendAddDialogClick) {
      $scope.friendAddDialogShow = false;
    }else {
      $scope.friendAddDialogClick = false;
    }
  };

  $scope.addFriendClick = function(index, user_id) {
    $scope.friendAddDialogShow = true;
    $scope.addFriend_id = user_id;
    $scope.addFriend_index = index;
  };

  $scope.addFriend = function(user_id) {
    $scope.friendAddDialogShow = false;
    friendsFactory.create({
      friend_list: { to_user_id: user_id }
    },
    function() {
      messageFactory.show("フォローしました。");
      getUsers();
    },
    function() {
      messageFactory.show("フォローに失敗しました。");
      getUsers();
    });
  };
}]);
