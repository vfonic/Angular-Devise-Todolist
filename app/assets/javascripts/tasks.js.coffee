root = global ? window

angular.module("tasks", ["ngResource"]).factory "Task", ['$resource', ($resource) ->
  Task = $resource("/tasks/:id/:action",
    id: "@id"
    action: "@action"
  ,
    update:
      method: "PUT"

    destroy:
      method: "DELETE"

    up:
      method: "PUT"
      params:
        action: "up"
    down:
      method: "PUT"
      params:
        action: "down"
    complete:
      method: "PUT"
      params:
        action: "complete"
  )
  Task::up = (cb) ->
    Task.up
      id: @id
    , cb
  Task::down = (cb) ->
    Task.down
      id: @id
    , cb
  Task::destroy = (cb) ->
    Task.remove
      id: @id
    , cb
  Task::complete = (cb) ->
    Task.complete
      id: @id
      completed: true
    , cb
  Task::uncomplete = (cb) ->
    Task.update
      id: @id
      completed: false
    , cb

  Task
]
root.angular = angular
