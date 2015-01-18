require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid user signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", 
                              email: "invalid@email,com", 
                              password: "foo",
                              password_confirmation: "bar" }
    end
  assert_template 'users/new'
  end

  test "valid user signup" do
    get signup_path
    assert_difference 'User.count', 1 do 
      post_via_redirect users_path, user: { name: "Test",
                               email: "test@email.com",
                               password: "foobar",
                               password_confirmation: "foobar" }
       end
    assert_template 'users/show'
    end

end
