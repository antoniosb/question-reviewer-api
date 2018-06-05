class AuthController < ApplicationController
  def initialize
    @service = UserService.new
  end
  def token
    user = @service.login(params)
    if !user
      render status: 401
    else
      render json: { :user => user, :token => JsonWebToken.encode(user.id) }, status: :ok
    end
  end
end
