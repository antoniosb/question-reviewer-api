require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get auth error" do
    post auth_token_url, :params => { :auth => { :login => "login", :password => "secret" } }
    assert_response 404
  end

  test "should get authorized" do 
    post auth_token_url, :params => { :auth => { :login => "login1", :password => "secret" } }
    assert_response :success
  end
end
