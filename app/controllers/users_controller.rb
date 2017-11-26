require 'pry'

class UsersController < ApplicationController
  def create
    if(params[:commit] === 'Cancel')
      goto_root
      return
    elsif params[:commit] === "Unregister Me"
      on_unreg_current_user
      return
    end

    if session[:dialog_mode] === 'signin'
      on_sign_in
    elsif session[:dialog_mode] === 'signup'
      on_sign_up
    elsif session[:dialog_mode] === 'edit'
      on_edit
    else
      goto_root
    end
  end

  private
  def login_params
    params.require(:user).permit(:loginname, :password)
  end

  def signup_params
    params.require(:user).permit(:loginname, :password, :fullname, :image)
  end

  def on_unreg_current_user
    if logged_in?
      @user.destroy
      @user.delete_file
    end
    @user=nil
    session[:user_id] = nil
    goto_root
  end

  def on_sign_in
    if logged_in?
      goto_root
      return
    end

    @user = User.find_by_loginname(login_params[:loginname])
    if( @user && @user.authenticate(login_params[:password]))
      session[:user_id] = @user.id
      goto_root
    else
      redirect_to '/signin', notice: 'Unknown login name or incrrect password'
    end
  end

  def on_sign_up
    if logged_in?
      goto_root
      return
    end

    @user = User.new(signup_params)
    if( !@user.valid? )
      redirect_to '/signup', notice: 'Your information is not valid.'
    elsif !@user.save_file
      redirect_to '/signup', notice: 'An error occured on saving image file.'
    elsif !@user.save
      redirect_to '/signup', notice: 'An error occured on saving your information into database.'
    else
      session[:user_id] = @user.id
      goto_root
    end
  end

  def on_edit
    if !logged_in?
      goto_root
      return
    end

    user = User.new(signup_params)
    if user.image && !user.save_file
      redirect_to '/edit', notice: 'An error occured on saving image file.'
    else
      tempuser = @user.deep_dup
      @user.loginname = user.loginname
      @user.fullname = user.fullname
      @user.password = user.password
      @user.image = user.image
      if !@user.save
        @user = User.find_by_id(session[:user_id])
        if @user != nil
          redirect_to '/edit', notice: 'An error occured on saving your information into database.'
        else
          goto_root
        end
      else
        tempuser.delete_file
        goto_root
      end
    end
  end
end
