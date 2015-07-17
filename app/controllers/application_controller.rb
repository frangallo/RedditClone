class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def log_in_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    unless @checked
      @current_user ||= User.find_by(session_token: session[:session_token])
      @checked = true
    end
  end

  def log_out_user!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end
end
