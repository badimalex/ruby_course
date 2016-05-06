class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_answer, only: [:destroy]
  before_action :load_question

  def new
    @answer = Answer.new
  end

  def create
    # это хорошая практика в контроллере делать?
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Your answer successfully removed'
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
