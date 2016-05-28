module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote]
  end

  def upvote
    @votable.increment!(:score, 1)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
