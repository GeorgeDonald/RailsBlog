require 'pry'

class UsersController < ApplicationController
  def create
    if(params[:commit] == 'Cancel')
      session[:dialog_mode] = nil
      redirect_to '/'
      return
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
      @user = User.new(signup_params)
      if( !@user.valid? )
        redirect_to '/signup', notice: 'Your information is not valid.'
      elsif !@user.save_file
        redirect_to '/signup', notice: 'An error occured on saving image file.'
      elsif !@user.save
        redirect_to '/signup', notice: 'An error occured on saving your information into database.'
      else
        session[:user_id] = @user.id
        session[:dialog_mode] = nil
        redirect_to '/'
      end
    elsif session[:dialog_mode] === 'edit'
      user = User.new(signup_params)
      if( !user.valid? )
        redirect_to '/signup', notice: 'Your information is not valid.'
      elsif !user.save_file
        redirect_to '/signup', notice: 'An error occured on saving image file.'
      els !@user.save
        redirect_to '/signup', notice: 'An error occured on saving your information into database.'
      else
        session[:user_id] = @user.id
        session[:dialog_mode] = nil
        redirect_to '/'
      end
    else
      session[:dialog_mode] = nil
      redirect_to '/'
    end
  end

  private
  def login_params
    params.require(:user).permit(:loginname, :password)
  end

  def signup_params
    params.require(:user).permit(:loginname, :password, :fullname, :image)
  end

end
