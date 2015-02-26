var recordsSummaryApp = angular.module('recordsSummaryApp', ['ngResource']);

recordsSummaryApp.config(
  ["$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }]
);

/*
recordsSummaryApp.controller('summaryController', ['$scope', 'JsonData', function($scope, JsonData) { 
  JsonData.getRecords().then(function(response){
    $scope.records = response.data;
    //$scope.show_loading = false;
  });
  //$scope.show_loading = true;
}]);
*/

recordsSummaryApp.controller('userSummaryController', function($scope, $resource) {
  var res = $resource('/api/account/records/total');
  $scope.total = res.get(function() {
    $scope.userLoading = true
  }, 
  function() {
    $scope.total = {"record": "-- ", "won": "-- ", "lost": "-- ", "rate": "-- "}
    $scope.userLoading = true
  });
});

recordsSummaryApp.controller('gundamSummaryController', function($scope, $resource) {
  var res = $resource('/api/account/records/summary');
  $scope.records = res.query(function() {
    $scope.recordsLoading = true
    $scope.loadingSuccess = true
  }, 
  function () {
    $scope.recordsLoading = true
    $scope.loadingFailed = true
  });
});
