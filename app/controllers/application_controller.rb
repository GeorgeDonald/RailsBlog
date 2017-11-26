class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :goto_root

  def current_user
    @user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    !!current_user && @user.loginname
  end

  def goto_root
    session[:dialog_mode] = nil
    redirect_to '/'
  end
end
