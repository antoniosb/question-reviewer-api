class RevisionsController < ApplicationController
  before_action :authenticate_request
  def initialize
    @service = QuestionService.new
  end  
  def create
    render json: @service.review(params, current_user), status: :ok
  end
end
