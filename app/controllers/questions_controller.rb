class QuestionsController < ApplicationController
  before_action :authenticate_user
  def initialize
    @service = QuestionService.new
  end  
  def index
    render json: @service.list_by_status_and_user(params[:status], current_user), status: :ok, include: [:question_alternatives, :question_revisions]
  end

  def show
    render json: @service.show(params[:id], current_user), status: :ok, include: [:question_alternatives, :question_revisions]
  end

  def create
    render json: @service.create(params, current_user), status: 201
  end

  def update
    render json: @service.update(params, current_user), status: :ok
  end
end
