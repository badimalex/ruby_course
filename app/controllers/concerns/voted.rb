module Voted
  extend ActiveSupport::Concern

  def upvote
    @question.increment!(:score, 1)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end
end
