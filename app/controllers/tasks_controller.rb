class TasksController < ApplicationController
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
      render json: { task: @task, message: "Tasks updated" }, status: :ok
    end
  end

  def complete
    @task = current_user.tasks.find(params[:id])
    @task.completed = params[:completed]

    message = @task.completed ? @task.title + " completed" : "Marked " + @task.title + " as not completed"

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render json: { task: @task, message: message}, status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def reorder
    @tasks = current_user.tasks.scoped.prioritized
    destination_task_index = params[:destination].to_i
    index = params[:source].to_i
    direction = destination_task_index < index ? -1 : 1
    priority = @tasks[destination_task_index].priority.to_i
    Task.transaction do
      task = @tasks[index]
      task.priority = priority
      task.save
      while index != destination_task_index
        index = index + direction
        task = @tasks[index]
        task.priority = task.priority - direction
        task.save
      end
    end
    render json: { message: "Tasks updated" }, status: :ok
  end

  def clear_completed
    @tasks = current_user.tasks.scoped.prioritized.where("completed_at IS NOT NULL")
    @tasks.destroy_all
    render json: { message: "Cleared completed tasks" }, status: :ok
  end

  def index
    @tasks = current_user.tasks.scoped.prioritized

    respond_to do |format|
      format.html { render nothing: true, layout: true }
      format.json { render json: @tasks }
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      format.html { render nothing: true, layout: true }
      format.json { render json: @task }
    end
  end

  def new
    @task = Task.new

    respond_to do |format|
      format.html { render nothing: true, layout: true }
      format.json { render json: @task }
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
    render nothing: true, layout: true
  end

  def create
    @task = Task.new(params[:task])
    @task.user = current_user
    @task.priority = (Task.maximum(:id) || 0) + 1
    @task.importance = params[:importance]

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: { task: @task, message: "Task created"}, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])
    @task.title = params[:title]
    @task.importance = params[:importance]

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render json: { task: @task, message: 'Task was successfully updated.'}, status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    render json: @task, status: :ok
  end
end
