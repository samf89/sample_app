module SessionsHelper

  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # return the current user if one exists
  def current_user 
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
