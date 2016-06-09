class CommentsController < ApplicationController
  def create
    @question = Question.find(params[:id])
    @comment = @question.comments.new(comment_params)
    if @comment.save
      redirect_to question_path(@comment.commentable)
    else
      render :new
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable

  end
end
