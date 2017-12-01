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

  def editblog
    show_blogs
  end

  def showcomment
    show_blogs
  end

  def editcomment
    if !logged_in?
      goto_root
      return
    end

    @comment = Comment.find_by_id(params[:id])
    if @comment.user_id != @user.id
      goto_root
      return
    end
    session[:comment_id] = params[:id]
    proc_req("editcomment")
  end

  def create
    if(params[:commit] === 'Cancel' || !logged_in?)
      goto_root
      return
    end

    if session[:dialog_mode] === "write"
      on_write_blog
    elsif session[:dialog_mode] === "editblog"
      on_edit_blog
    elsif session[:dialog_mode] === "comment"
      on_comment_blog
    else
      goto_root
    end
  end

  def comment
    if valid_blog?
      session[:blog_id] = params[:id]
      @comment = Comment.new
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
    session[:blog_id] = params[:id]
    proc_req("editblog")
  end

  def nextpage
    if session[:from_number] == nil
      session[:from_number] = 0
    else
      session[:from_number] += 10
    end
    goto_root
  end

  def prevpage
    if session[:from_number] == nil
      session[:from_number] = 0
    else
      session[:from_number] -= 10
    end
    goto_root
  end

  private
  def show_blogs
    if !logged_in?
      redirect_to '/'
    else
      render :show
    end
  end

  def on_write_blog
    @blog = Blog.new(blog_params)
    @blog.user_id = session[:user_id]

    if !@blog.save
      redirect_to '/write', notice: "An error occured while saving the blog."
    else
      goto_root
    end
  end

  def on_edit_blog
    if !logged_in? || !session[:blog_id]
      goto_root
    end

    @blog = Blog.find_by_id(session[:blog_id])
    if !@blog || @blog.user_id != @user.id
      goto_root
    end

    blog=Blog.new(blog_params)
    @blog.title = blog.title
    @blog.contents = blog.contents

    if !@blog.save
      @blog = Blog.find_by_id(session[:blog_id])
      redirect_to "/blogs/#{@blog.id}", notice: "An error occured while saving the blog."
    else
      session[:blog_id]=nil
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
    @blogs =Blog.all.reverse
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
