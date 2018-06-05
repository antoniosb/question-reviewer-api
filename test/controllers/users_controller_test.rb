require 'test_helper'

class UsersControllerTest  < ActionDispatch::IntegrationTest
  test "should get bad request error on signup" do
    post users_url, :params => { }
    assert_response 400
  end
  test "should get conflict error on signup" do
    post users_url, :params => { :login => "login1", :password => "secret" }
    assert_response :conflict
  end
  test "should get success on signup" do
    post users_url, :params => { :login => "loginnovo", :password => "secret" }
    assert_response :success
    assert json_response["token"] != nil
  end
end
