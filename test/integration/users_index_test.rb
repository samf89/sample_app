require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:test_user_one)
    @non_admin = users(:archer)
  end

  # test that delete links appear and work for admin user
  test "index including pagination and admin only links" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: user.name, method: :delete
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  # test that no delete links appear for a non-admin user
  test "index as non-admin" do
    log_in_as (@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
