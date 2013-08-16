angular.module('spinner', [])
    .config(function ($httpProvider) {
        $httpProvider.responseInterceptors.push('spinnerInterceptor');
        var spinnerFunction = function (data, headersGetter) {
            $(".spinner").show()
            return data;
        };
        $httpProvider.defaults.transformRequest.push(spinnerFunction);
    })
    .factory('spinnerInterceptor', function ($q, $window) {
        return function (promise) {
            return promise.then(function (response) {
                $(".spinner").hide()
                return response;

            }, function (response) {
                $(".spinner").hide()
                return $q.reject(response);
            });
        };
    })
