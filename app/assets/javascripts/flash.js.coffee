thisApp.factory("FlashService", ($rootScope) ->
  return {
    show: (message) ->
      $rootScope.flash = message
    clear: ->
      $rootScope.flash = ""
  }
)
