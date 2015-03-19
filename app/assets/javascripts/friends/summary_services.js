fvistFoundationApp.factory("friendsSummaryFactory", ["$resource", function($resource) {
  return $resource("/api/account/records/friends/summary");
}]);
