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

  def week
    @calendar_week = params[:week].split('-')[1]
    @calendar_year = params[:week].split('-')[0]
    @user = User.find(session[:user_id])
    tasks = Task.where(user_id: session[:user_id]).reject { |task| task.category == 'break' }.sort_by(&:created_at)
    @week = sort_by_week(tasks, @calendar_week, @calendar_year)
    @ausbildungsjahr = calculate_ausbildungsjahr(@week, @user.start_of_training, @calendar_week)
    @starting_day = find_starting_day(@week, @calendar_week)

    respond_to do |format|
      format.html do
        render template: "tasks/print.html.erb",
               locals: { tasks: @week, user: @user, week: @calendar_week, year: @calendar_year, abteilung: @user.department, ausbildungsjahr: @ausbildungsjahr, starting_day: @starting_day }
      end
      format.pdf do
        render pdf: "Ausbildungsnachweis-#{@calendar_year}-#{@calendar_week}",
               template: "tasks/print.pdf.erb",
               locals: { tasks: @week, user: @user, week: @calendar_week, year: @calendar_year, abteilung: @user.department, ausbildungsjahr: @ausbildungsjahr, starting_day: @starting_day }
      end
    end
  end

  private

  def find_starting_day(week, calendar_week)
    starting_day = 0
    week.each_with_index do |day, i|
      next if day[calendar_week].nil?
      if starting_day == 0
        starting_day = i
      else
        return starting_day
      end
    end
    starting_day
  end

  def calculate_ausbildungsjahr(week, beginn_ausbildung, calendar_week)
    ausbildungsjahr = 0
    week.each do |day|
      next if day[calendar_week].nil?
      # add one because even though the difference in years is zero, it is the first year of learning stuff
      ausbildungsjahr = difference_in_years(beginn_ausbildung, day[calendar_week].first.created_at) + 1
    end
    ausbildungsjahr
  end

  # gives back the number of completed years between a start_date and a date
  def difference_in_years(startdate, date)
    # Difference in years, minus one if startdate has not recurred this year.
    a = date.year - startdate.year
    a = a - 1 if ( startdate.month >  date.month or (startdate.month >= date.month and startdate.day > date.day) )
    a
  end

  def sort_by_week(tasks, calendar_week, calendar_year)
    monday = {}
    tuesday = {}
    wednsday = {}
    thursday = {}
    friday = {}

    tasks.each do |task|
      year = task.created_at.strftime('%Y')
      week = task.created_at.strftime('%V')
      day = task.created_at.strftime('%u')

      if year != calendar_year
        next
      else
        if week != calendar_week
          next
        else
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
      end
    end

    [monday, tuesday, wednsday, thursday, friday]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :category, :user_id, :active, :duration, :created_at, :updated_at, :started_at, :stopped_at)
  end
end
