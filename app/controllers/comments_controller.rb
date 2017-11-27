class CommentsController < ApplicationController
  def create
    if params[:commit] == 'Cancel' || !logged_in?
      goto_root
      return
    end

    if session[:dialog_mode] === "comment"
      on_create_comment
    elsif session[:dialog_mode] === "editcomment"
      on_edit_comment
    else
      goto_root
    end
  end

  def delete
    if !logged_in?
      goto_root
      return
    end

    @comment = Comment.find_by_id(params[:id])
    if @comment.user_id != @user.id
      goto_root
      return
    end

    if @comment != nil
      @comment.destroy
      @comment = nil
    end
    goto_root
  end

  private
  def on_create_comment
    @blog = Blog.find_by_id(session[:blog_id])
    if !@blog
      goto_root
      return
    end

    @comment = Comment.new(comment_params)
    @comment.user_id = @user.id
    @comment.blog_id = @blog.id
    if !@comment.save
      redirect_to "/comments/#{blog.id}", notice: "An error occured while saving the comment."
    else
      goto_root
    end
  end

  def on_edit_comment
    @comment = Comment.find_by_id(session[:comment_id])
    if !@comment || @comment.user_id != @user.id
      goto_root
    end
    comment = Comment.new(comment_params)
    @comment.contents = comment.contents

    if !@comment.save
      redirect_to "/comments/#{bcomment.id}", notice: "An error occured while saving the comment."
    else
      goto_root
    end
  end

  def comment_params
    params.require(:comment).permit(:contents)
  end
end
