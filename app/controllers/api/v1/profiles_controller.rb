class Api::V1::ProfilesController < ApplicationController
  # doorkeeper_for :all

  respond_to :json

  def me
    respond_with current_user
  end
end
