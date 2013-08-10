root = global ? window

TasksIndexCtrl = ($scope, Task) ->
  $scope.tasks = Task.query() || {}

  $scope.destroy = ->
    if confirm("Are you sure?")
      original = @task
      @task.destroy ->
        $scope.tasks = _.without($scope.tasks, original)
  $scope.up = ->
    return if _.indexOf($scope.tasks, @task) == 0
    higherTask = $scope.tasks[_.indexOf($scope.tasks, @task)-1]
    higherTask.priority++
    @task.priority--
    # todo: make this one query
    # todo: update after the query
    # todo: swap array elements
    # todo: if it's the last one ignore
    # todo: ignore everything server-side
    Task.update @task
    Task.update higherTask
        
TasksIndexCtrl.$inject = ['$scope', 'Task'];

TasksCreateCtrl = ($scope, $location, Task) ->
  $scope.save = ->
    Task.save $scope.task, (task) ->
      $location.path "/tasks"

TasksCreateCtrl.$inject = ['$scope', '$location', 'Task'];

TasksShowCtrl = ($scope, $location, $routeParams, Task) ->
  Task.get
    id: $routeParams.id
  , (task) ->
    @original = task
    $scope.task = new Task(@original)

  $scope.destroy = ->
    if confirm("Are you sure?")
      $scope.task.destroy ->
        $location.path "/tasks"

TasksShowCtrl.$inject = ['$scope', '$location', '$routeParams', 'Task'];

TasksEditCtrl = ($scope, $location, $routeParams, Task) ->
  Task.get
    id: $routeParams.id
  , (task) ->
    @original = task
    $scope.task = new Task(@original)

  $scope.isClean = ->
    console.log "[TasksEditCtrl, $scope.isClean]"
    angular.equals @original, $scope.task

  $scope.destroy = ->
    if confirm("Are you sure?")
      $scope.task.destroy ->
        $location.path "/tasks"

  $scope.save = ->
    Task.update $scope.task, (task) ->
      $location.path "/tasks"

TasksEditCtrl.$inject = ['$scope', '$location', '$routeParams', 'Task'];

# exports
root.TasksIndexCtrl  = TasksIndexCtrl
root.TasksCreateCtrl = TasksCreateCtrl
root.TasksShowCtrl   = TasksShowCtrl
root.TasksEditCtrl   = TasksEditCtrl 
