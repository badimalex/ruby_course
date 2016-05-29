module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:upvote]
  end

  def upvote
    unless current_user.author_of?(@voteable)
      @voteable.upvote!
      render json: @voteable
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
