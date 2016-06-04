module Voted
  include Exceptions
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:up_vote, :down_vote, :un_vote]

    rescue_from OwnerVotedError, AlreadyVotedError do |exception|
      render json: { error: exception.to_s }, status: :forbidden
    end
  end

  def down_vote
    unless current_user
      render json: { error: 'Only autorized user can vote' }, status: :forbidden
    else
      current_user.down_vote(@voteable)
      render json: @voteable, methods: [:rating]
    end
  end

  def up_vote
    unless current_user
      render json: { error: 'Only autorized user can vote' }, status: :forbidden
    else
      current_user.up_vote(@voteable)
      render json: @voteable, methods: [:rating]
    end
  end

  def un_vote
    unless current_user
      render json: { error: 'Only autorized user can vote' }, status: :forbidden
    else
      current_user.un_vote(@voteable)
      render json: @voteable, methods: [:rating]
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
