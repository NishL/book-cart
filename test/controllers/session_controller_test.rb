require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should prompt for login" do
    get login_url
    assert_response :success
  end

  test "should login" do
    james = users(:one)
    post login_url, params: { name: james.name, password: 'secret'}
    assert_redirected_to admin_url
    assert_equal james.id, session[:user_id]
  end

  test "should fail login" do
    james = users(:one)
    post login_url, params: { name: james.name, password: 'wrongpassword'}
    assert_redirected_to login_url
  end

  test "should get destroy" do
    delete logout_url
    assert_redirected_to store_index_url
  end

end
