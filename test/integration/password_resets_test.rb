require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup 
    ActionMailer::Base.deliveries.clear
    @user = users(:test_user_one)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, password_reset: { email: " " }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: " ")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password and confirmation
    patch password_reset_path(user.reset_token), email: user.email, user: { password: "foo", password_confirmation: "bar" }
    assert_select 'div#error_explanation'
    # Blank password
    patch password_reset_path(user.reset_token), email: user.email, user: { password: "", password_confirmation: "bar" }
    assert_not flash.empty?
    assert_template 'password_resets/edit'
    # Valid password and confirmation
    patch password_reset_path(user.reset_token), email: user.email, user: { password: "foobaz", password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired password reset token" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path, password_reset: { email: @user.email }
    @user = assigns(:user)
    # Set the time the link was sent to be three hours ago
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    # Send patch with valid information
    patch password_reset_path(@user.reset_token), email: @user.email, user: { password: "foobaz", password_confirmation: "foobaz" }
    assert_response :redirect
    follow_redirect!
    # Test that the html body contains the work expired
    assert_not flash.empty?
    assert_match /expired/, response.body
  end
    
end
