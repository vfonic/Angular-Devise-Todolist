root = global ? window
angular = root.angular

thisApp = angular.module("ToptalTodolist", ['ngResource', 'ngCookies', 'tasks'])
thisApp.run(($rootScope, $location, FlashService) ->
  $rootScope.$on('$routeChangeStart', (event, next, current) ->
    FlashService.clear()
    if ($location.path() != '/login' && $location.path() != '/register' && !$rootScope.authorized())
      FlashService.show("You need to sign in or sign up before continuing.")
      $location.path('/register')
    else if (($location.path() == '/login' || $location.path() == '/register') && $rootScope.authorized())
      $location.path('/')
  )
)

root.thisApp = thisApp
