module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:upvote]
  end

  def upvote
    if @voteable.upvoted?
      render json: { error: 'You can not vote twice' }, status: :forbidden
    else
      unless current_user.author_of?(@voteable)
        @voteable.upvote!
        render json: @voteable
      end
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
