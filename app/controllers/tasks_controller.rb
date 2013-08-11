class TasksController < ApplicationController
  before_filter :authenticate_user!

  def up_down
    @tasks = current_user.tasks.scoped.uncompleted.prioritized
    task_index = @tasks.index { |task| task.id == params[:id].to_i }
    @task = @tasks[task_index]

    if (task_index == 0 and params[:direction] == "up") or
      (task_index == @tasks.size - 1 and params[:direction] = "down")
      head :no_content
    else
      delta_direction = params[:direction] == "up" ? -1 : 1;
      @higherTask = @tasks[task_index + delta_direction]
      priority = @higherTask.priority
      Task.transaction do
        @higherTask.update_attribute(:priority, @task.priority)
        @task.update_attribute(:priority, priority)
      end
      head :no_content
    end
  end

  def complete
    @task = current_user.tasks.find(params[:id])
    @task.completed = params[:completed]

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render json: @task, status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
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
    @task.priority = Task.maximum(:id).next

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    head :no_content
  end
end
