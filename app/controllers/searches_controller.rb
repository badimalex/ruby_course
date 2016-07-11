class SearchesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_params, only: [:index]

  def index
    @results = Search.find(@query, @section) if (@query and @section)
  end

  private
  def set_params
    @query = params[:query]
    @section = params[:section]
  end
end
