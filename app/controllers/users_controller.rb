class UsersController < ApplicationController
  def initialize
    @service = UserService.new
  end  
  def create
    user = @service.create(params)
    render json: { :user => user, :token => JsonWebToken.encode(user.id) }, status: 201
  end
end
