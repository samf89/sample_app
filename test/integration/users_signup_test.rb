require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

  test "valid user signup" do
    get signup_path
    assert_difference 'User.count', 1 do 
      post_via_redirect users_path, user: { name: "Test",
                               email: "test@email.com",
                               password: "foobar",
                               password_confirmation: "foobar" }
       end
    assert_template 'users/show'
    assert_not_nil flash
    end

end
