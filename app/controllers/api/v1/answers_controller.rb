class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show]

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_resource_owner)))
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
