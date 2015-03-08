fvistFoundationApp.controller("recordsIndexController", ["$scope", "$resource", "recordFactory", function($scope, $resource, recordFactory) {
  $scope.records = [];
  $scope.page = 0;
  $scope.recordsMax = document.getElementById("records__max").value;
  $scope.recordLimited = false;

  $scope.getRecords = function(page) {
    $scope.recordsLoading = true;
    var res = $resource("/api/account/records?page=" + page);
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
    $scope.page++;
    $scope.getRecords($scope.page);
  };
}]);
