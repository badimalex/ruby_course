class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :up_vote, :down_vote, :un_vote]

  rescue_from 'Exception' do |exception|
    render json: { error: exception.to_s }, status: :forbidden
  end

  def un_vote
    unless current_user
      render json: { error: 'Only autorized user can vote' }, status: :forbidden
    else
      current_user.un_vote(@question)
      render json: @question, methods: [:rating]
    end
  end

  def down_vote
    unless current_user
      render json: { error: 'Only autorized user can vote' }, status: :forbidden
    else
      current_user.down_vote(@question)
      render json: @question, methods: [:rating]
    end
  end

  def up_vote
    unless current_user
      render json: { error: 'Only autorized user can vote' }, status: :forbidden
    else
      current_user.up_vote(@question)
      render json: @question, methods: [:rating]
    end
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
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
