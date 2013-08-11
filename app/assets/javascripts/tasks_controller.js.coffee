root = global ? window

swap = (array, first_index, second_index) ->
  tmp = array[first_index]
  array[first_index] = array[second_index]
  array[second_index] = tmp
  return array

TasksIndexCtrl = ($scope, Task) ->
  $scope.tasks = Task.query()

  $scope.save = ->
    Task.save @task, (task) ->
      $scope.tasks.push(task)
      $scope.task.title = ""

  $scope.up = ->
    # indexOfTask = _.indexOf($scope.tasks, @task)
    # return if indexOfTask == 0
    # higherTask = $scope.tasks[indexOfTask-1]
    # task = @task

    @task.up ->
      # higherTask.priority++
      # task.priority--
      # swap($scope.tasks, indexOfTask, indexOfTask-1)
  $scope.down = ->
    # indexOfTask = _.indexOf($scope.tasks, @task)
    # return if indexOfTask == $scope.tasks.length - 1
    # lowerTask = $scope.tasks[indexOfTask+1]
    task = @task

    @task.down ->
      # lowerTask.priority--
      # task.priority++
      # swap($scope.tasks, indexOfTask, indexOfTask+1)

  $scope.destroy = ->
    if confirm("Are you sure?")
      original = @task
      @task.destroy ->
        $scope.tasks = _.without($scope.tasks, original)

  $scope.complete = ->
    original = @task
    @task.complete ->
      original.completed = true

  $scope.uncomplete = ->
    original = @task
    @task.uncomplete ->
      # TODO change this with setting received task from server
      original.completed = false
        
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
