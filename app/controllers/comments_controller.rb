class CommentsController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @comment = @question.comments.new(comment_params)
    if @comment.save
      redirect_to question_path(@comment.question)
    else
      render :new
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
