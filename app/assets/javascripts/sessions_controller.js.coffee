thisApp.controller 'SessionsCtrl', ($scope, $http, $location, FlashService, $rootScope) ->
  $rootScope.current_user = JSON.parse($("meta[name='current_user']").attr('content'))

  $scope.authorized = ->
    $rootScope.current_user? and $rootScope.current_user.id?

  $scope.login = ->
    authData = {user: {email: $scope.email, password: $scope.password}}

    $http(
      method: "POST"
      url: "/login"
      data: authData
    )
    .success (data) ->
      $rootScope.current_user = data
      $("meta[name='current_user']").attr('content', JSON.stringify(data))
      $location.path "/tasks"
      FlashService.show("Welcome!")
    .error (data, status) ->
      FlashService.show(data['error'])

  $scope.logout = ->
    $http(
      method: "DELETE"
      url: "/logout"
    )
    .success (data) ->
      $rootScope.current_user = null
      $("meta[name='current_user']").attr('content', "null")
      $location.path "/login"
      FlashService.show(data)
    .error (data, status) ->
      FlashService.show("Error: #{status}.\n#{data}")

  $scope.register = ->
    registerData = {authenticity_token: "$cookieStore.get('XSRF-TOKEN')", user: {name: $scope.name, email: $scope.email, password: $scope.password, password_confirmation: $scope.password}}

    $http(
      method: "POST"
      url: "/users"
      data: registerData
    )
    .success (data) ->
      $rootScope.current_user = data
      $("meta[name='current_user']").attr('content', JSON.stringify(data))
      $location.path "/tasks"
      FlashService.show("Welcome!")
    .error (data) ->
      FlashService.show(data['error'])
