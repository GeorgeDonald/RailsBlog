require 'pry'

class BlogsController < ApplicationController
  def show
    current_user
    session[:dialog_mode] = nil
  end

  def signin
    if logged_in?
      redirect_to '/'
    else
      proc_req("signin")
    end
  end

  def signup
    if logged_in?
      redirect_to '/'
    else
      proc_req("signup")
    end
  end

  def edit
    if !logged_in?
      redirect_to '/'
    else
      proc_req("edit")
    end
  end

  def logout
    session[:user_id] = nil
    @user = nil
    redirect_to '/'
  end

  private
  def proc_req(answer)
    session[:dialog_mode] = answer

    if !@user
      @user = User.new
    end

    render :show
  end
end
