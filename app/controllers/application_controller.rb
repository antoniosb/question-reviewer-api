class ApplicationController < ActionController::API
  attr_reader :current_user

  rescue_from ForbiddenException do |exception|
    render status: 403
  end
  rescue_from ValidationException do |exception|
    render status: 400, json: exception.errors
  end
  rescue_from ActiveRecord::RecordNotUnique do |exception|
    render status: 409
  end

  def authenticate_request
    user_id = JsonWebToken.decode(request.headers[:Authorization])
    @current_user = UserService.new().show(user_id)
    raise StandardError.new unless @current_user
  rescue
    render json: { :user => @current_user }, status: 401
  end
end
