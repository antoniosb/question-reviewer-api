require 'simplecov'
SimpleCov.start
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  def authenticated_header_admin
    token = Knock::AuthToken.new(payload: { sub: users(:two).id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  def json_response
      ActiveSupport::JSON.decode @response.body
  end

  # Add more helper methods to be used by all tests here...
end
