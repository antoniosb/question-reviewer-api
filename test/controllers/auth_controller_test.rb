require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get auth error" do
    post auth_token_url, :params => { :login => "login", :password => "secret" }
    assert_response 401
  end

  test "should get authorized" do 
    post auth_token_url, :params => { :login => "login1", :password => "secret" }
    assert_equal "login1", json_response["user"]["login"]
    assert_response :success
  end
end
