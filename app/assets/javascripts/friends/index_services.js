fvistFoundationApp.filter("followerListFilter", ["$rootScope", "$filter", function($rootScope, $filter) {
  return function(items, input) {
    var result = $filter("filter")(items, input);
    $rootScope.filtedFollower = result;
    return result;
  };
}]);
