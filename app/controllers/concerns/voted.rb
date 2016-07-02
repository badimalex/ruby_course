module Voted
  include Exceptions
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:up_vote, :down_vote, :un_vote]

    rescue_from OwnerVotedError, AlreadyVotedError do |exception|
      render json: { error: exception.to_s }, status: :forbidden
    end

    rescue_from CanCan::AccessDenied do |exception|
      render json: { error: exception.to_s }, status: :forbidden
    end
  end

  def down_vote
    authorize! :down_vote, @voteable
    current_user.down_vote(@voteable)
    render json: @voteable, methods: [:rating]
  end

  def up_vote
    authorize! :up_vote, @voteable
    current_user.up_vote(@voteable)
    render json: @voteable, methods: [:rating]
  end

  def un_vote
    authorize! :un_vote, @voteable
    current_user.un_vote(@voteable)
    render json: @voteable, methods: [:rating]
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
