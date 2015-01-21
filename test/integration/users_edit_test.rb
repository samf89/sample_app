require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  setup :user

  test "user redirected after unsuccessful update" do 
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "",
                                    password: "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  private 
    def user
      @user = users(:test_user_one)
    end
end
