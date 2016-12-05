class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # shows the tasks of the current user
  # GET /tasks
  # GET /tasks.json
  def index
    tasks = Task.where(user_id: session[:user_id])
    @tasks = tasks.sort_by(&:created_at)
  end

  # shows all the tasks of all users
  def all_tasks
    @tasks = Task.all
    render :index
  end

  # shows a single task
  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @user = current_user
  end

  # GET /tasks/1/edit
  def edit
    @user = current_user
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.start

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_url, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def start
    @task = Task.find(params[:id])
    @task.start unless @task.active?
    redirect_to tasks_url
  end

  def stop
    @task = Task.find(params[:id])
    @task.stop if @task.active?
    redirect_to tasks_url
  end

  def print_tasks
    tasks = Task.where(user_id: session[:user_id]).reject { |task| task.category == 'break' }
    @tasks = tasks.sort_by(&:created_at)
    @user = User.find(session[:user_id])

    monday = {}
    tuesday = {}
    wednsday = {}
    thursday = {}
    friday = {}

    @tasks.each do |task|
      week = task.created_at.strftime('%V')
      day = task.created_at.strftime('%u')
      case day
        when '1'
          if monday[week].nil?
            monday[week] = [task]
          else
            monday[week] << task
          end
        when '2'
          if tuesday[week].nil?
            tuesday[week] = [task]
          else
            tuesday[week] << task
          end
        when '3'
          if wednsday[week].nil?
            wednsday[week] = [task]
          else
            wednsday[week] << task
          end
        when '4'
          if thursday[week].nil?
            thursday[week] = [task]
          else
            thursday[week] << task
          end
        when '5'
          if friday[week].nil?
            friday[week] = [task]
          else
            friday[week] << task
          end
      end
    end

    weeks = [monday, tuesday, wednsday, thursday, friday]

    respond_to do |format|
      #format.html
      format.pdf do
        render pdf: "Ausbildungsnachweis_#{@tasks.first.created_at}",
               template: "tasks/print.pdf.erb",
               locals: { tasks: weeks, user: @user }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :category, :user_id, :active, :duration, :created_at, :updated_at, :started_at, :stopped_at)
  end
end
