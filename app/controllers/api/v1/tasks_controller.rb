class Api::V1::TasksController < Api::V1::BaseApiController
  before_filter :authenticate_user!

  def up_down
    @tasks = current_user.tasks.scoped.prioritized
    task_index = @tasks.index { |task| task.id == params[:id].to_i }
    @task = @tasks[task_index]

    if (task_index == 0 and params[:direction] == "up") or
      (task_index == @tasks.size - 1 and params[:direction] == "down")
      render json: { error: "Trying to move the first task up or the last task down" }, status: :unprocessable_entity
    else
      delta_direction = params[:direction] == "up" ? -1 : 1;
      @higherTask = @tasks[task_index + delta_direction]
      priority = @higherTask.priority
      Task.transaction do
        @higherTask.update_attribute(:priority, @task.priority)
        @task.update_attribute(:priority, priority)
      end
      render json: @task, status: :ok
    end
  end

  def complete
    @task = current_user.tasks.find(params[:id])
    @task.completed = params[:completed]

    if @task.save
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def index
    @tasks = current_user.tasks.scoped.prioritized

    render json: @tasks
  end

  def show
    @task = current_user.tasks.find(params[:id])
    render json: @task
  end

  def create
    @task = Task.new(params[:task])
    @task.user = current_user
    @task.priority = Task.maximum(:id).next

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update_attributes(params[:task])
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    render json: @task, status: :ok
  end
end
