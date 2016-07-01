class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index]
  before_action :load_answer, only: [:show]

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
