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
    reorder:
      method: "PUT"
      params:
        action: "reorder"
    clear_completed:
      method: "PUT"
      params:
        action: "clear_completed"
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
  Task::complete = (complete, cb) ->
    Task.complete
      id: @id
      completed: complete
    , cb
  Task::reorder = (params) ->
    Task.reorder
      source: params.source
      destination: params.destination
  Task::clear_completed = (cb) ->
    Task.clear_completed cb

  Task
]
root.angular = angular
