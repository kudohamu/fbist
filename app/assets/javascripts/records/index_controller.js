fvistFoundationApp.controller("recordsIndexController", ["$scope", "$resource", "recordFactory", function($scope, $resource, recordFactory) {
  $scope.records = [];
  $scope.page = 0;
  $scope.recordsMax = document.getElementById("records__max").value;
  $scope.recordLimited = false;

  $scope.getRecords = function() {
    $scope.recordsLoading = true;
    var res = $resource("/api/account/records?offset=" + $scope.records.length);
    res_records = res.query(function() {
      res_records.map(function(record) { $scope.records.push(record) });
      $scope.recordsLoading = false;

      if ($scope.recordsMax <= $scope.records.length) {
        $scope.recordLimited = true;
      }
    });
  };
  $scope.getRecords($scope.page);

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
      $scope.showMessage("1件のデータを削除しました。");
    });
  }

  $scope.deleteRecordClick = function(id, index) {
    $scope.delete_record = $scope.records[index];
    $scope.delete_index = index;
    $scope.deleteRecordDivShow = !$scope.deleteRecordDivShow;
  }

  $scope.showMessage = function(message) {
    $scope.message = message;
    $scope.show = true;
  }

}]);
