class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update, :index, :destroy]

  # Routes
  # Shows all the users
  def index
    @users = User.all
  end

  # Shows the user profile
  def show
    # This will get the route of the user with the id entered in the
    # path but the before_action :correct_user will redirect the user
    # to the path with his user_id depending on the session id.
    @users = User.where(id: params[:id])
    tasks = Task.where(user_id: session[:user_id])
    # binding.pry
    @tasks = tasks.sort_by(&:created_at)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to TaskR!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user ||= current_user # User.find_by(id: session[:user_id])
    @user.destroy
    log_out
    redirect_to root_url
  end

  # Methods

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms only the correct user can access his routes. Redirects to current users profile if route does not match users id.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(profile_url(id: session[:user_id])) unless current_user?(@user)
  end
end
