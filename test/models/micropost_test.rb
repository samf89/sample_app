# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:test_user_one)
    #This code is not idiomatically correct
    @micropost = @user.microposts.build(content: "Lorem Ipsum")
  end

  test "micropost should be valid" do
    assert @micropost.valid?
  end

  test "micropost should have a user id" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "micropost content should not exceed 140 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end

  test "micropost should have content" do
    @micropost.content = "      "
    assert_not @micropost.valid?
  end

  test "microposts should be retrieved in most recent order" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
