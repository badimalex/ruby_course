class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author_of?(@attachment.attachmentable)
      @attachment.destroy
    else
      render status: :forbidden
    end
  end
end
