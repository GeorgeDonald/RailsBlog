require 'pry'

class BlogsController < ApplicationController
  def show
    current_user
  end
  
  def signin
    proc_req("signin")
  end

  def signup
    proc_req("signup")
  end

  private
  def proc_req(answer)
    if !logged_in?
      session[:dialog_mode] = answer
      @user = User.new
      render :show
    else
      redirect_to '/'
    end
  end
end
