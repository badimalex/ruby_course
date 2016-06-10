class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.save
    render :create
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = find_commentable
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
