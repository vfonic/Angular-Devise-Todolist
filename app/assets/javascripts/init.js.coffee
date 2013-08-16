root = global ? window
angular = root.angular

thisApp = angular.module("ToptalTodolist", ['ngResource', 'ngCookies', 'tasks', 'spinner', 'ui.sortable'])
thisApp.run(($rootScope, $location, FlashService) ->
  $rootScope.$on('$routeChangeStart', (event, next, current) ->
    if ($location.path() != '/login' && $location.path() != '/register' && !$rootScope.authorized())
      $location.path('/register')
      FlashService.error("You need to register or login before continuing.")
    else if (($location.path() == '/login' || $location.path() == '/register') && $rootScope.authorized())
      $location.path('/')

    if ($location.path() != '/login' && $location.path() != '/register')
      FlashService.clear()
  )
)

root.thisApp = thisApp
