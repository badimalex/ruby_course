class AttachmentsController < ApplicationController
  before_action :load_entity
  before_action :check_author
  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def check_author
    unless current_user.author_of?(@attachment.attachmentable)
      render status: :unprocessable_entity
    end
  end

  def load_entity
    @attachment = Attachment.find(params[:id])
  end
end
