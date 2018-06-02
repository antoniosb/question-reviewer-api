class ApplicationController < ActionController::API
  include Knock::Authenticable
  rescue_from ForbiddenException do |exception|
    render status: 403
  end
  rescue_from ValidationException do |exception|
    render status: 400, json: exception.errors
  end
  rescue_from ActiveRecord::RecordNotUnique do |exception|
    render status: 409
  end
end
