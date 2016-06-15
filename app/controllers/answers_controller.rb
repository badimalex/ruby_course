class AnswersController < ApplicationController
  include PublicIndex, PublicShow, Voted

  before_action :load_answer, only: [:destroy, :update, :accept]
  before_action :load_question, only: [:create, :update, :accept]
  before_action :check_author, only: [:destroy, :update, :accept]

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def accept
    respond_with(@answer.accept!)
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

  def check_author
    unless current_user.author_of?(@answer)
      render status: :forbidden
    end
  end
end
