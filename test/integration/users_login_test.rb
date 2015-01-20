require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  setup :user

  test "login with invalid user information" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "",
                                password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?, "The flash shouldn't have been empty"
    get root_path
    assert flash.empty?, "The flash should have been empty"
  end

  test "login with valid user information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user, "Not redirected to @user"
    follow_redirect!
    assert_template 'users/show', "The show template wasn't displayed"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

  private
    def user
      @user = users(:test_user_one)
    end

end
