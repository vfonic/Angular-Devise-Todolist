thisApp.controller 'UsersCtrl', ($scope, $http, $location, FlashService, $rootScope) ->
  $rootScope.current_user = JSON.parse($("meta[name='current_user']").attr('content'))

  $rootScope.authorized = ->
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
      $location.path "/"
      # FlashService.show("Welcome!")
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
      # explicitly redirect to /register in order to skip calling tasks#index for guest user
      $location.path "/register"
      FlashService.show(data)
    .error (data, status) ->
      FlashService.show("Error: #{status}.\n#{data}")

  $scope.register = ->#(user) ->
    # $http.post('/users.json', {user: {email: email, password: password, password_confirmation: confirm_password} })
    #             .then(function(response) {
    #                 service.currentUser = response.data;
    #                 if (service.isAuthenticated()) {
    #                     $location.path('/record');
    #                 }
    #             });
    # FlashService.clear()
    # Session.register(user.email, user.password, user.confirm_password)
    #   .then(
    #     (response) -> # success
    #       FlashService.show(response)
    #     (response) -> # error
    #       $.each(response.data.errors, (index, value) ->
    #                 errors += index.substr(0,1).toUpperCase()+index.substr(1) + ' ' + value + ''
    #             )
    #             FlashService.show(errors)
    #         )
    registerData = {user: {name: $scope.name, email: $scope.email, password: $scope.password, password_confirmation: $scope.password}}

    $http(
      method: "POST"
      url: "/register"
      data: registerData
    )
    .success (data) ->
      $rootScope.current_user = data
      $("meta[name='current_user']").attr('content', JSON.stringify(data))
      $location.path "/"
      FlashService.show("Welcome!")
      console.log("s, %o", data)
    .error (data) ->
      FlashService.show(data['error'])
      console.log("e, %o", data)
