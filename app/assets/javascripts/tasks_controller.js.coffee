root = global ? window

swap = (array, first_index, second_index) ->
  tmp = array[first_index]
  array[first_index] = array[second_index]
  array[second_index] = tmp
  return array

TasksIndexCtrl = ($scope, Task) ->
  $scope.tasks = Task.query()
  $scope.colors = [
    {name: 'Red', value: 'red'}
    {name: 'Yellow', value: 'yellow'}
    {name: 'Green', value: 'green'}
  ]
  $scope.task = {"importance": "yellow"}

  $scope.save = ->
    Task.save @task, (data) ->
      $scope.tasks.push(new Task(data.task))
      $scope.task.title = ""
      $scope.task.importance = "yellow"

  $scope.up = ->
    indexOfTask = _.indexOf($scope.tasks, @task)
    return if indexOfTask == 0
    higherTask = $scope.tasks[indexOfTask-1]
    task = @task

    @task.up ->
      priority = higherTask.priority
      higherTask.priority = task.priority
      task.priority = priority
      swap($scope.tasks, indexOfTask, indexOfTask-1)
  $scope.down = ->
    indexOfTask = _.indexOf($scope.tasks, @task)
    return if indexOfTask == $scope.tasks.length - 1
    lowerTask = $scope.tasks[indexOfTask+1]
    task = @task

    @task.down ->
      priority = lowerTask.priority
      lowerTask.priority = task.priority
      task.priority = priority
      swap($scope.tasks, indexOfTask, indexOfTask+1)

  $scope.destroy = ->
    original = @task
    bootbox.confirm("Are you sure?", (response) ->
      if response
        original.destroy ->
          $scope.tasks = _.without($scope.tasks, original)
    )

  $scope.complete = (complete) ->
    original = @task
    @task.complete complete, ->
      original.completed = complete

  $scope.sortableOptions = {
    stop: (e, ui) ->
        from = ui.item.sortable.index
        to = ui.item.index()
        Task.reorder {
          source: from,
          destination: to
        }
  }

TasksIndexCtrl.$inject = ['$scope', 'Task'];

TasksCreateCtrl = ($scope, $location, Task) ->
  $scope.save = ->
    Task.save $scope.task, (data) ->
      $location.path "/tasks"

TasksCreateCtrl.$inject = ['$scope', '$location', 'Task'];

TasksShowCtrl = ($scope, $location, $routeParams, Task) ->
  Task.get
    id: $routeParams.id
  , (task) ->
    @original = task
    $scope.task = new Task(@original)

  $scope.destroy = ->
    bootbox.confirm("Are you sure?", (response) ->
      if response
        $scope.task.destroy ->
          $location.path "/tasks"
    )

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
    bootbox.confirm("Are you sure?", (response) ->
      if response
        $scope.task.destroy ->
          $location.path "/tasks"
    )

  $scope.save = ->
    Task.update $scope.task, (data) ->
      $location.path "/tasks"

TasksEditCtrl.$inject = ['$scope', '$location', '$routeParams', 'Task'];

# exports
root.TasksIndexCtrl  = TasksIndexCtrl
root.TasksCreateCtrl = TasksCreateCtrl
root.TasksShowCtrl   = TasksShowCtrl
root.TasksEditCtrl   = TasksEditCtrl 
