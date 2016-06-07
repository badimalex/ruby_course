class QuestionsController < ApplicationController
  include PublicIndex, PublicShow, Voted

  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @comment = @question.comments.build
    @answer.attachments.build
    @answer.comments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully removed'
    else
      redirect_to @question, notice: 'You cannot mess with another author\'s post'
    end
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
      PrivatePub.publish_to "/questions", question: @question.to_json
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
