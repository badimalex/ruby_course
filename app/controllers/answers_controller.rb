class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_answer, only: [:destroy, :update]
  before_action :load_question

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    return unless current_user.author_of?(@answer)
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully removed'
    else
      flash[:notice] = 'You cannot mess with another author\'s answer'
    end
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
