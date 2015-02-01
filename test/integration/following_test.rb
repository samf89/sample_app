require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test_user_one)
    @other_user = users(:archer)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user| 
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.following.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "follow user with html request" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other_user.id
    end
  end

  test "unfollow user with html request" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "follow with ajax request" do 
    assert_difference '@user.following.count', 1  do 
      xhr :post, relationships_path, followed_id: @other_user.id
    end
  end

  test "unfollow with ajax request" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end

end
