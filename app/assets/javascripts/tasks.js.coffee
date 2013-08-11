root = global ? window

angular.module("tasks", ["ngResource"]).factory "Task", ['$resource', ($resource) ->
  Task = $resource("/tasks/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    destroy:
      method: "DELETE"

    up:
      method: "PUT"
    down:
      method: "PUT"
  )
  Task::up = (cb) ->
    Task.up
      id: "up"
      task_id: @id
    , cb
  Task::down = (cb) ->
    Task.down
      id: "down"
      task_id: @id
    , cb
  Task::destroy = (cb) ->
    Task.remove
      id: @id
    , cb
  Task::complete = (cb) ->
    Task.update
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
