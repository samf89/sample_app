require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid user signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", 
                              email: "", 
                              password: "foo",
                              password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div #error_explanation'
    assert_select 'div .field_with_errors', 8
    assert_select 'div #error_explanation' do 
      assert_select 'ul' do 
        assert_select 'li', 5
      end
    end
  end

#  test "valid user signup" do
#    get signup_path
#    assert_difference 'User.count', 1 do 
#      post_via_redirect users_path, user: { name: "Test",
#                               email: "test@email.com",
#                               password: "foobar",
#                               password_confirmation: "foobar" }
#       end
#    assert_template 'users/show'
#    assert is_logged_in?
#    assert_not_nil flash
#  end

  test "valid signup with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do 
      post users_path, user: { name: "Example User", 
                               email: "user@example.com",
                               password: "password",
                               password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user) # assign @user from controller to the user variable
    assert_not user.activated?
    # try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # valid token wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert !is_logged_in?
    # valid activation token and correct email
#    assert user.activation_token, "User has an activation token"
#    puts user.activation_token
#    puts user.activation_digest
#    puts user.authenticated?(:activation, user.activation_token)
#    get edit_account_activation_path(user.activation_token, email: user.email)
#    assert user.reload.activated?, "The user should be activated"
#    follow_redirect!
#    assert_template 'users/show'
#    assert is_logged_in?
  end


end
