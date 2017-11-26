require 'pry'

class BlogsController < ApplicationController
  before_action :get_blogs, except: [:create]

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

  def write
    if !logged_in?
      redirect_to '/'
    else
      @blog = Blog.new
      proc_req("write")
    end
  end

  def create
    if(params[:commit] === 'Cancel' || !logged_in?)
      goto_root
      return
    end

    if session[:dialog_mode] === "write"
      on_write_blog
    elsif session[:dialog_mode] === "editblog"
    elsif session[:dialog_mode] === "comment"
    else
      goto_root
    end
  end

  def comment
    if valid_blog?
      proc_req("comment")
    end
  end

  def delete
    if !valid_blog?(true)
      return
    end
    @blog.destroy
    goto_root
  end

  def editblog
    if !valid_blog?(true)
      return
    end
    proc_req("editblog")
  end

  private
  def on_write_blog
    @blog = Blog.new(blog_params)
    @blog.user_id = session[:user_id]

    if !@blog.save
      redirect_to '/write', notice: "An error occured while saving the blog."
    else
      goto_root
    end
  end

  def valid_blog? (req_same = false)
    if !logged_in?
      goto_root
      return false
    end
    @blog=Blog.find_by_id(params[:id])
    if !@blog
      goto_root
      return false
    end
    if req_same
      if @user.id != @blog.user_id
        goto_root
        return false
      end
    end
    true
  end

  def get_blogs
    @blogs =Blog.all
  end

  def blog_params
    params.require(:blog).permit(:title, :contents)
  end

  def proc_req(answer)
    session[:dialog_mode] = answer

    if !@user
      @user = User.new
    end

    render :show
  end
end
