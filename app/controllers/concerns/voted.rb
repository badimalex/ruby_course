module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:upvote, :downvote]
  end

  def downvote
    if @voteable.downvoted?(current_user)
      render json: { error: 'You can not vote twice' }, status: :forbidden
    else
      unless current_user.author_of?(@voteable)
        @voteable.downvote!(current_user)
        render json: @voteable
      end
    end
  end

  def upvote
    if @voteable.upvoted?(current_user)
      render json: { error: 'You can not vote twice' }, status: :forbidden
    else
      unless current_user.author_of?(@voteable)
        @voteable.upvote!(current_user)
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
