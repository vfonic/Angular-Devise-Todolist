thisApp.controller 'SessionsCtrl', ($scope, $http, $location) ->
  $scope.current_user = JSON.parse($("meta[name='current_user']").attr('content'))
  $scope.authErrors = []

  $scope.authorized = ->
    $scope.current_user? and $scope.current_user.id?

  $scope.login = ->
    $scope.authErrors = []
    authData = {user: {email: $scope.email, password: $scope.password}}

    $http(
      method: "POST"
      url: "/login"
      data: authData
    )
    .success (data) ->
      $scope.current_user = data
      $("meta[name='current_user']").attr('content', JSON.stringify(data))
      $location.path "/tasks"
    .error (data, status) ->
      $scope.authErrors = data['error']

  $scope.logout = ->
    $http(
      method: "DELETE"
      url: "/logout"
    )
    .success (data) ->
      $scope.current_user = null
      $("meta[name='current_user']").attr('content', "null")
      $location.path "/login"
    .error (data, status) ->
      alert("Error: #{status}.\n#{data}")

# thisApp.run(($rootScope, $location) ->
#   $rootScope.$on('$routeChangeStart', (event, next, current) ->
#     if ($location.path() != '/login' and $location.path() != '/register' and !$scope.authorized())
#         $location.path('/login')
#   )
# )
