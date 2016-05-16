class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_answer, only: [:destroy, :update, :accept]
  before_action :load_question, only: [:create, :update, :accept]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      flash[:notice] = 'You cannot mess with another author\'s post'
    end
  end

  def destroy
    return unless current_user.author_of?(@answer)
    @answer.destroy
  end

  def accept
    return unless current_user.author_of?(@question)
    @answer.accept!
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
