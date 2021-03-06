# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default("f")
#  activation_digest :string
#  activated         :boolean          default("f")
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = '   '
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ' '
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not exceed 250 characters" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "valid emails should be allowed" do
    valid_addresses = %w[user@example.com USER@foo.com US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "invalid emails should not be allowed" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have minimum length of 6" do
    @user.password =  @user.password_confirmation = "fooba"
    assert_not @user.valid?
  end

  test "emails should be saved as lower case" do
    mixed_case_email = "tEsT@EMail.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal @user.reload.email, mixed_case_email.downcase
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "user microposts should be destroyed when user is deleted" do
    @user.save
    @user.microposts.create!(content: "lorem ipsum")
    assert_difference 'Micropost.count ', -1 do
      @user.destroy
    end
  end

  test "following and unfollowing a user" do
    user_one = users(:test_user_one)
    user_two = users(:archer)
    assert_not user_one.following?(user_two)
    user_one.follow(user_two)
    assert user_one.following?(user_two)
    assert user_two.followers.include?(user_one)
    user_one.unfollow(user_two)
    assert_not user_one.following?(user_two)
  end

  test "feed should have the right posts" do
    user_one = users(:test_user_one)
    archer = users(:archer)
    lana = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert user_one.feed.include?(post_following)
    end
    # Posts from self
    user_one.microposts.each do |post_self|
      assert user_one.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed| 
      assert_not user_one.feed.include?(post_unfollowed)
    end
  end

end
