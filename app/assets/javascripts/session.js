thisApp.run(function($rootScope, $location, Session) {
  $rootScope.$on('$routeChangeStart', function(event, next, current) {
    if ($location.path() !== '/login' && $location.path() !== '/register' && !Session.signedIn) {
        // $location.path('/login');
    }
  });
});

thisApp.service('Session',[ '$cookieStore', 'UserSession', 'UserRegistration', function($cookieStore, UserSession, UserRegistration) {

  this.currentUser = $cookieStore.get('_angular_devise_user');
  this.signedIn = !!$cookieStore.get('_angular_devise_user');
  this.signedOut = !this.signedIn;
  this.userSession = new UserSession( { email:"foo@bar.com", password:"example", remember_me:true } );
  this.userRegistration = new UserRegistration( { email:"foo-" + Math.floor((Math.random()*10000)+1) + "@bar.com", password:"example", password_confirmation:"example" } );

}]);
