fvistFoundationApp.factory("graphFactory", ["$resource", function($resource) {
  return $resource("/api/account/records/graph");
}]);
