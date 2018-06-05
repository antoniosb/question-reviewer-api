require 'test_helper'

class QuestionsControllerTest  < ActionDispatch::IntegrationTest
  def after_setup
    get questions_url, headers: authenticated_header_admin
    @other_question_id = json_response[0]["id"]
    @my_question_id = json_response[2]["id"]
    @my_reproved_question_id = json_response[1]["id"]
    alternatives = Array.new
    alternatives << { :content => "Option 1", :is_correct => false }
    alternatives << { :content => "Option 2", :is_correct => false }
    alternatives << { :content => "Option 3", :is_correct => false }
    alternatives << { :content => "Option 4", :is_correct => false }
    alternatives << { :content => "Option 5", :is_correct => true }

    @valid_question = { :content => "Nova", :source => "Source", :year => 2000, :alternatives => alternatives }
  end
  test "should get auth error" do
    get questions_url
    assert_response 401
  end
  test "should get only my questions" do
    get questions_url, headers: authenticated_header
    assert_response :success
    assert_equal 2, json_response.length
    assert_equal "login1", json_response[0]["user"]["login"]
  end

  test "should get all questions" do
    get questions_url, headers: authenticated_header_admin
    assert_response :success
    assert_equal 3, json_response.length
  end

  test "should get questions by status 'Pendente'" do
    get "/questions?status=P", headers: authenticated_header_admin
    assert_response :success
    assert_equal 1, json_response.length
  end

  test "should get questions by status 'Aprovado'" do
    get "/questions?status=A", headers: authenticated_header_admin
    assert_response :success
    assert_equal 1, json_response.length
  end

  test "should get questions by status 'Reprovado'" do
    get "/questions?status=R", headers: authenticated_header_admin
    assert_response :success
    assert_equal 1, json_response.length
  end

  test "should get my question by id" do
    url = "/questions/#{@my_question_id}"
    get url, headers: authenticated_header
    assert_response :success
    assert_equal "login1", json_response["user"]["login"]
  end

  test "should get error on get question of other user" do
    url = "/questions/#{@other_question_id}"
    get url, headers: authenticated_header
    assert_response 403
  end

  test "should get error on get invalid question" do
    assert_raises ActiveRecord::RecordNotFound do
      url = "/questions/0"
      get url, headers: authenticated_header
    end
  end

  test "should get error on create question without required fields" do
    alternatives = Array.new
    alternatives << { :content => "Option 1", :is_correct => false }
    alternatives << { :content => "Option 2", :is_correct => false }
    alternatives << { :content => "Option 3", :is_correct => false }
    alternatives << { :content => "Option 4", :is_correct => false }
    alternatives << { :is_correct => false }

    data = { :source => "Source", :year => 2000, :alternatives => alternatives }
    post questions_url, :params => data, headers: authenticated_header
    assert_response 400
  end

  test "should get error on create question with invalid alternatives type" do
    post questions_url, :params => { :content => "Nova", :source => "Source", :year => 2000, :alternatives => "" }, headers: authenticated_header
    assert_response 400
  end

  test "should get error on create question with invalid alternatives count" do
    data = { :content => "Nova", :source => "Source", :year => 2000, :alternatives => [] }
    post questions_url, :params => data, headers: authenticated_header
    assert_response 400
  end

  test "should get error on create question with alternative without required fields" do
    alternatives = Array.new
    alternatives << { :content => "Option 1", :is_correct => false }
    alternatives << { :content => "Option 2", :is_correct => false }
    alternatives << { :content => "Option 3", :is_correct => false }
    alternatives << { :content => "Option 4", :is_correct => false }
    alternatives << { :is_correct => false }

    data = { :content => "Nova", :source => "Source", :year => 2000, :alternatives => alternatives }
    post questions_url, :params => data, headers: authenticated_header
    assert_response 400
  end

  test "should get success on create question" do
    post questions_url, :params => @valid_question, headers: authenticated_header
    assert_response :success
  end

  test "should get forbidden error on review question with not admin user" do
    post "/questions/#{@my_question_id}/revisions", headers: authenticated_header
    assert_response 403
  end

  test "should get error on review question without status" do
    post "/questions/#{@my_question_id}/revisions", headers: authenticated_header_admin, :params => {}
    assert_response 400
    assert_equal 1, json_response["status"].length
  end

  test "should get error on review question with invalid status" do
    post "/questions/#{@my_question_id}/revisions", headers: authenticated_header_admin, :params => { :status => "P" }
    assert_response 400
    assert_equal 1, json_response["status"].length
  end

  test "should get error on review invalid question" do
    assert_raises ActiveRecord::RecordNotFound do
      post "/questions/888/revisions", headers: authenticated_header_admin, :params => { :status => "A" }
    end
  end

  test "should get error on review not pendent question" do
    post "/questions/#{@other_question_id}/revisions", headers: authenticated_header_admin, :params => { :status => "A" }
    assert_response 400
    assert_equal 1, json_response["status"].length
  end

  test "should get error on review without comment" do
    post "/questions/#{@my_question_id}/revisions", headers: authenticated_header_admin, :params => { :status => "A" }
    assert_response 400
    assert_equal 1, json_response["comment"].length
  end

  test "should get success on review question" do
    post "/questions/#{@my_question_id}/revisions", headers: authenticated_header_admin, :params => { :status => "R", :comment => "Comment" }
    assert_response :success
    assert_equal "R", json_response["status"]
  end

  test "should get error on update invalid question" do
    assert_raises ActiveRecord::RecordNotFound do
      url = "/questions/0"
      put url, headers: authenticated_header
    end
  end

  test "should get forbidden error on update question of other user" do
    put "/questions/#{@other_question_id}", headers: authenticated_header
    assert_response 403
  end

  test "should get error on update not reproved question" do
    put "/questions/#{@other_question_id}", headers: authenticated_header_admin, :params => @valid_question
    assert_response 400
    assert_equal 1, json_response["status"].length
  end

  test "should get success on update reproved question" do
    put "/questions/#{@my_reproved_question_id}", headers: authenticated_header, :params => @valid_question
    assert_response 200
  end
end
