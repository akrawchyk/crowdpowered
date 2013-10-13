class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.save


    flash[:notice] = "Comment has been created!"
    redirect_to @comment.commentable
  end

  private
  def comment_params
    params.require(:comment).permit(:comment, :commentable_id, :commentable_type)
  end
end