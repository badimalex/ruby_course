class AnswersController < ApplicationController
  include PublicIndex, PublicShow

  before_action :load_answer, only: [:destroy, :update, :accept]
  before_action :load_question, only: [:create, :update, :accept]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      render status: :forbidden
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      render status: :forbidden
    end
  end

  def accept
    if current_user.author_of?(@question)
      @answer.accept!
    else
      render status: :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
