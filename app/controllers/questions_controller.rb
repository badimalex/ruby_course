class QuestionsController < ApplicationController
  include PublicIndex, PublicShow, Voted

  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :build_comment, only: :show

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
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully removed'
    else
      flash[:notice] = 'You cannot mess with another author\'s post'
    end
    respond_with @question
  end

  def update
    if current_user.author_of?(@question)
      @question.update(questions_params)
    else
      render status: :forbidden
    end
  end

  def create
    @question = current_user.questions.new(questions_params)
    if @question.save
      PrivatePub.publish_to '/questions', question: @question.to_json
      flash[:notice] = 'Your question successfully created.'
    end
    respond_with @question
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
end
