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
    $scope.userLoading = true;
  }, 
  function() {
    $scope.total = {"record": "-- ", "won": "-- ", "lost": "-- ", "rate": "-- "};
    $scope.userLoading = true;
  });
});

recordsSummaryApp.controller('gundamSummaryController', function($scope, $resource) {
  $scope.sort = { 'no': true, 'total': false, 'won': false, 'lost': false, 'rate': false };
  $scope.asc = true;

  var res = $resource('/api/account/records/summary');
  $scope.records = res.query(function() {
    $scope.reverse = false;
    $scope.predicate = "no";
    $scope.recordsLoading = true;
    $scope.loadingSuccess = true;
    $scope.options_costs = [
      { "name": "ALLコスト", "cost": 0 },
      { "name": "3000", "cost": 3000 },
      { "name": "2500", "cost": 2500 },
      { "name": "2000", "cost": 2000 },
      { "name": "1000", "cost": 1000 }
    ];
    $scope.filter_cost = $scope.options_costs[0].cost;
  }, 
  function () {
    $scope.recordsLoading = true;
    $scope.loadingFailed = true;
  });

  $scope.thClick = function(pred) {
    if ($scope.predicate == pred) {
      $scope.reverse = !$scope.reverse;
      $scope.asc = !$scope.asc;
    }else {
      $scope.predicate = pred;
      $scope.reverse = false;
      $scope.asc = true;

      $scope.sort['no'] = false;
      $scope.sort['total'] = false;
      $scope.sort['won'] = false;
      $scope.sort['lost'] = false;
      $scope.sort['rate'] = false;

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
});
