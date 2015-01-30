require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup 
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Lorem Ipsum" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do 
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy action for wrong micropost" do
    log_in_as(users(:test_user_one))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end

end
