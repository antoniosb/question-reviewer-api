class UsersController < ApplicationController
  def initialize
    @service = UserService.new
  end  
  def create
    render json: @service.create(params), status: 201
  end
end
