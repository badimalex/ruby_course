class QuestionsController < ApplicationController
  include PublicIndex, PublicShow, Voted

  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :build_comment, only: :show
  before_action :check_author, only: [:destroy, :update]
  after_action :publish_question, only: :create

  respond_to :js

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    respond_with(@question.update(questions_params))
  end

  def create
    respond_with (@question = current_user.questions.create(questions_params))
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def build_comment
    @comment = @question.comments.build
  end

  def check_author
    unless current_user.author_of?(@question)
      redirect_to @question
    end
  end

  def publish_question
    PrivatePub.publish_to '/questions', question: @question.to_json
  end
end
