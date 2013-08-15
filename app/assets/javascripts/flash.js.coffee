thisApp.config(($httpProvider) ->

    interceptor = ($rootScope, $q, FlashService) ->
      success = (response) -> 
        console.log("success!")
        console.log(response)
        console.log(response.data.message)
        if (response && response.data.message)
          message = response.data.message
          FlashService.show(message)
          $rootScope.$on('$routeChangeSuccess', (event, next, current) ->
            FlashService.show(message)
          )
        return response
 
      error = (response) -> 
        console.log("error!")
        console.log(response)
        if (response)
          if (response.data.errors)
            errors = ""
            $.each(response.data.errors, (index, value) ->
              errors += index.substr(0,1).toUpperCase() + index.substr(1) + ' ' + value + '<br>'
            )
            FlashService.error(errors)
          else if (response.data.error)
            FlashService.error(response.data.error)
        return $q.reject(response)

      (promise) ->
        promise.then(success, error)

    $httpProvider.responseInterceptors.push(interceptor)
)

thisApp.factory("FlashService", ($rootScope) ->
  return {
    show: (message) ->
      $rootScope.flash = message
    error: (message) ->
      $rootScope.flash = message
    clear: ->
      $rootScope.flash = ""
  }
)
