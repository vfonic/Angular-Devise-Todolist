root = global ? window

angular.module("tasks", ["ngResource"]).factory "Task", ['$resource', ($resource) ->
  Task = $resource("/tasks/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    destroy:
      method: "DELETE"
  )
  Task::destroy = (cb) ->
    Task.remove
      id: @id
    , cb

  Task
]
root.angular = angular
