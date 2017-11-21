require 'pry'

class UsersController < ApplicationController
  def new
    binding.pry
    redirect_to '/' if logged_in?
    @user = User.new
  end

  def create
    if(params[:commit] == 'Cancel')
      session[:dialog_mode] = nil
      redirect_to '/'
    end

    if session[:dialog_mode] === 'signin'
      @user = User.find_by_loginname(login_params[:loginname])
      if( @user && @user.authenticate(login_params[:password]))
        session[:user_id] = @user.id
        session[:dialog_mode] = nil
        redirect_to '/'
      else
        redirect_to '/signin', notice: 'Unknown login name or incrrect password'
      end
    elsif session[:dialog_mode] === 'signup'
    else
      session[:dialog_mode] = nil
      redirect_to '/'
    end
  end

  def cancel
    session[:dialog_mode] = nil
    redirect_to '/'
  end

  private
  def login_params
    params.require(:user).permit(:loginname, :password, :fullname, :image)
  end
end
