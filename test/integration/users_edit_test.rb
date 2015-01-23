require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  setup :user

  test "unsuccessful user edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "",
                                    password: "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful user edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "Test User",
                                    email: "test123@email.com",
                                    password: "foobar",
                                    password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "Test User"
    assert_equal @user.email, "test123@email.com"
  end

  test "successful edit with friendly forwarding" do 
    get edit_user_path(@user) # not yet logged in
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    name = "Foo bar"
    email = "foobar@email.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  private 
    def user
      @user = users(:test_user_one)
    end
end
