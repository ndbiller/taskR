module ApplicationHelper
  # Before filters
  # Confirms a logged-in user. Redirects to log in if not.
  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
