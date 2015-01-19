require 'test_helper'

class UsersLogoutTest < ActionDispatch::IntegrationTest

  setup :user

  test "user is able to log out" do
    get login_path
    post_via_redirect login_path, session: { email: @user.email, password: "password" }
    assert is_logged_in?
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
  end

  private
    def user
      @user = users(:test_user_one)
    end

end
