module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote]
  end

  def upvote
    unless current_user.author_of?(@votable)
      @votable.upvote!
      render json: @votable
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
