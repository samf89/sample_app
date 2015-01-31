# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup 
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  test "relationship should be valid" do
    assert @relationship.valid?
  end

  test "relationship requires follower id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "relationship required followed id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

end
