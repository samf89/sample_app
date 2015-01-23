require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user_one = users(:test_user_one)
    @user_two = users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect from edit when not logged in" do
    get :edit, id: @user_one
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user_one, user: { name: @user_one.name, email: @user_one.email }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect on edit when logged in as wrong user" do 
    log_in_as @user_two
    get :edit, id: @user_one
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect on update when logged in as wrong user" do
    log_in_as @user_two
    patch :update, id: @user_one, user: { name: @user_one.name, email: @user_one.email }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect on index when not logged in" do
    get :index
    assert_redirected_to login_path
  end

  test "should get index when logged in" do
    log_in_as @user_one
    get :index
    assert_response :success
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user_one
    end
    assert_redirected_to login_path
  end

  test "should redirect to root when not logged in as admin" do 
    log_in_as @user_two
    assert_no_difference 'User.count' do
      delete :destroy, id: @user_one
    end
    assert_redirected_to root_path
  end

end
