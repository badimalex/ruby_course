module Commented
  include Exceptions
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:add_comment]
  end

  def add_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.save
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end
