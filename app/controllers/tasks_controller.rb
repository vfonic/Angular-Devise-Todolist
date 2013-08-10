class TasksController < ApplicationController
  before_filter :authenticate_user!

  def up_down
    @tasks = current_user.tasks.scoped.prioritized
    @task = @tasks.find(params[:task_id])

    if (@task.priority == 0 and params[:direction] == :up) or
      (@task.priority == @tasks.count - 1 and params[:direction] = :down)
      head :no_content
    else
      begin
        deltaPriority = params[:direction] == :up ? -1 : 1;
        priority = @task.priority + deltaPriority
        @higherTask = @tasks.where(priority: priority).first
        Task.transaction do
          @higherTask.update_attributes!(priority: @task.priority)
          @task.update_attributes!(priority: priority)
        end
        head :no_content
      rescue ActiveRecord::RecordInvalid => invalid
        render json: {error: @task.errors, error: @higherTask.errors}, status: :unprocessable_entity
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

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
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
