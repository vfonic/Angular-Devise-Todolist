thisApp.config(($httpProvider) ->

    interceptor = ($rootScope, $q, FlashService) ->
      success = (response) ->
        if (response && response.data.message)
          message = response.data.message
          FlashService.show(message)
        return response
 
      error = (response) ->
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

thisApp.factory("FlashService", ($rootScope, $timeout) ->
  $rootScope.msg_id = 0
  return {
    show: (message) ->
      $rootScope.msg_id = $rootScope.msg_id + 1
      msg_id = $rootScope.msg_id
      $rootScope.flash = message
      $rootScope.message_type = "alert-info"
      $rootScope.$on('$routeChangeSuccess', (event, next, current) ->
        $rootScope.flash = message
      )
      $timeout( ->
        if $rootScope.msg_id == msg_id
          $(".alert").hide(300, ->
            $rootScope.flash = ""
            message = ""
          )
      , 2000 )
    error: (message) ->
      $rootScope.flash = message
      $rootScope.message_type = "alert-error"
    clear: ->
      $rootScope.flash = ""
  }
)
