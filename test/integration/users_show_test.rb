require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @active_user = users(:test_user_one)
    @non_active_user = users(:not_activated_user)
  end

  test "unable to view non activated user" do
    log_in_as @active_user
    assert @active_user.activated
    assert_not @non_active_user.activated
    # Attempt to view the user profile of the inactive user
    get user_path(@non_active_user.id)
    assert_redirected_to root_url
  end


end
